/*
    Парус 8 - Панели мониторинга - ТОиР - Выполнение работ
    Панель мониторинга: Корневая панель выполнения работ
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useContext, useCallback, useEffect } from "react"; //Классы React
import {
    Grid,   
    Paper,
    Box, 
    Link,
    Button, 
    Dialog, 
    DialogActions, 
    DialogContent, 
    DialogTitle, 
    InputLabel,
    FormControl,
    OutlinedInput,
    InputAdornment,
    IconButton, 
    Icon, 
    Select,
    MenuItem,
    FormHelperText
} from "@mui/material";
import { P8PDataGrid, P8P_DATA_GRID_SIZE } from "../../components/p8p_data_grid"; //Таблица данных
import { P8P_DATA_GRID_CONFIG_PROPS } from "../../config_wrapper"; //Подключение компонентов к настройкам приложения
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { ApplicationСtx } from "../../context/application"; //Контекст приложения
import { headCellRender, dataCellRender, groupCellRender, DIGITS_REG_EXP, MONTH_NAME_REG_EXP, DAY_NAME_REG_EXP } from "./layouts"; //Дополнительная разметка и вёрстка клиентских элементов

//-----------
//Тело модуля
//-----------

//Корневая панель выполнения работ
const EqsPrfrm = () => {
    //Собственное состояние - таблица данных
    const [dataGrid, setDataGrid] = useState({
        dataLoaded: false,
        columnsDef: [],
        groups: [],
        rows: [],
        reload: false
    });

    const [filter, setFilter] = useState({
        belong: "Демопример", 
        prodObj: "К2", 
        techServ: "", 
        respDep: "", 
        fromMonth: 1, 
        fromYear: 2024, 
        toMonth: 12, 
        toYear: 2024});

    // const [filter, setFilter] = useState({
    //     belong: "", 
    //     prodObj: "", 
    //     techServ: "", 
    //     respDep: "", 
    //     fromMonth: "", 
    //     fromYear: "", 
    //     toMonth: "", 
    //     toYear: ""});

    const [info, setInfo] = useState({cntP: 0, sumP: 0, cntF: 0, sumF: 0});

    //Подключение к контексту приложения
    const { pOnlineShowDictionary } = useContext(ApplicationСtx);

    const [filterOpen, setFilterOpen] = useState(false);

    const [filterCopy, setFilterCopy] = useState({...filter});

    const [filterLock, setFilterLock] = useState(false);

    const openFilter = () => {
        setFilterOpen(true);
    };

    const closeFilter = (e) => {
        if (filterLock && e != undefined) setFilter(filterCopy);
        setFilterOpen(false);
    };

    const clearFilter = () => {
        setFilter({
            belong: "", 
            prodObj: "", 
            techServ: "", 
            respDep: "", 
            fromMonth: "", 
            fromYear: "",
            toMonth: "", 
            toYear: ""});
    };
    
    let yearArray = [];
    let today = new Date();

    const getYearArray = () => {
        for (let i = 1990; i <= today.getFullYear(); i++) {
            yearArray.push(i);
        }
    };

    const monthArray = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]; 

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //Загрузка данных таблицы с сервера
    const loadData = useCallback(async () => {
        if (dataGrid.reload) {
            const data = await executeStored({
                stored: "PKG_P8PANELS_EQUIPSRV.EQUIPSRV_GRID",
                args: {
                    SBELONG: filter.belong,
                    SPRODOBJ: filter.prodObj,
                    STECHSERV: filter.techServ,
                    SRESPDEP: filter.respDep,
                    NFROMMONTH: filter.fromMonth,
                    NFROMYEAR: filter.fromYear,
                    NTOMONTH: filter.toMonth,
                    NTOYEAR: filter.toYear
                },
                respArg: "COUT",
                attributeValueProcessor: (name, val) => (["caption", "name", "parent"].includes(name) ? undefined : val)
            });
            let cP = 0;
            let sP =  0;
            let cF = 0;
            let sF = 0;
            let properties = [];
            if (data.XROWS != null)
            {
                data.XROWS.map((row) => {
                    properties = [];
                    Object.entries(row).forEach(([key, value]) =>
                        properties.push({ name: key, data: value }));         
                    if (properties[1].data == "Факт" || properties[2].data == "План")
                    {
                        if (properties[2].data == "План")
                        {
                            properties.map((p) => {
                                if (DAY_NAME_REG_EXP.test(p.name))
                                    cP = cP + 1;                 
                            }); 
                        }
                        else if (properties[1].data == "Факт")
                        {
                            properties.map((p) => {
                                if (DAY_NAME_REG_EXP.test(p.name))
                                    cF = cF + 1;                   
                            }); 
                        }                                     
                    }
                    else
                    {
                        properties.map((p) => {
                            if (MONTH_NAME_REG_EXP.test(p.name))
                            {
                                let str = p.data;
                                let m = [];
                                let i = 0;
                                while ((m = DIGITS_REG_EXP.exec(str)) != null) {
                                    if (i == 0)
                                        sP = sP + Number(m[0].replace(",", "."));
                                    else
                                    {
                                        sF = sF + Number(m[0].replace(",", "."));
                                    }
                                    i++;
                                }
                            }
                        });
                    }                
                });
            }
            setInfo({cntP: cP, sumP: sP, cntF: cF, sumF: sF});
            setDataGrid(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: [...(data.XROWS || [])],
                groups: [...(data.XGROUPS || [])],
                dataLoaded: true,
                reload: false
            }));
        }
    }, [dataGrid.reload, filter, executeStored]);

    //пользовательский параметр JuridicalPerson системы
    const getJurPers = useCallback(async () => {
        const data = await executeStored({
            stored: "PKG_P8PANELS_EQUIPSRV.GET_JUR_PERS_PRM",
            respArg: "CRES"
        });
        setFilter(pv => ({...pv, belong: data}));
    }, [executeStored]);

    useEffect(() => {
        if (filterOpen) 
        {
            setFilterCopy({...filter});
        }
    // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [filterOpen])

    //При необходимости обновить данные таблицы
    useEffect(() => {
        loadData();
    },[loadData, dataGrid.reload]);

    //Генерация содержимого 
    return (
        <div>
            {getYearArray()}
            <Dialog open={filterOpen} onClose={closeFilter}>
            <DialogTitle>Фильтр отбора</DialogTitle>
            <IconButton
                aria-label="close"
                onClick={closeFilter}
                sx={{
                    position: 'absolute',
                    right: 8,
                    top: 8,
                    color: (theme) => theme.palette.grey[500],
                }}
                >
                <Icon>close</Icon>
            </IconButton>
            <DialogContent>
                <Paper>
                    <Box component="section" sx = {{p: 1 }}>
                        <FormControl readOnly fullWidth variant="outlined">
                        <InputLabel htmlFor="belong-outlined">Принадлежность</InputLabel>
                            <OutlinedInput
                                error={filter.belong ? false : true}
                                id="belong-outlined"
                                value={filter.belong}
                                endAdornment={
                                    <InputAdornment position="end">
                                        <IconButton
                                            aria-label="belong select"
                                            onClick={() => {
                                                pOnlineShowDictionary({
                                                    unitCode: "JuridicalPersons",
                                                    callBack: res => (res.success === true ? setFilter(pv => ({...pv, belong: res.outParameters.out_CODE})) : null)
                                                });
                                            }}
                                            edge="end"
                                        >
                                            <Icon>list</Icon>
                                        </IconButton>
                                    </InputAdornment>
                                }
                                aria-describedby="belong-outlined-helper-text"
                                label="Принадлежность"
                            />
                            <Grid container>
                                <Grid item xs={6}>
                                    {filter.belong ? null : <FormHelperText id="belong-outlined-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                                </Grid>
                                <Grid item xs={6} sx={{textAlign: "end"}}>
                                    <Link component="button" 
                                          variant="body2"
                                          id="belong-outlined-link-btn" 
                                          sx={{fontSize: "0.75rem", marginRight: "35px"}}
                                          onClick={getJurPers}
                                          >
                                        Значение по умолчанию
                                    </Link>
                                </Grid>
                            </Grid>                           
                        </FormControl>
                    </Box>
                    <Box component="section" sx = {{p: 1 }}>
                        <FormControl readOnly fullWidth>
                            <InputLabel htmlFor="prodObj-outlined">Производственный объект</InputLabel>
                            <OutlinedInput
                                error={filter.prodObj ? false : true}
                                id="prodObj-outlined"
                                value={filter.prodObj}
                                endAdornment={
                                    <InputAdornment position="end">
                                        <IconButton
                                            aria-label="prodObj select"
                                            onClick={() => {
                                                pOnlineShowDictionary({
                                                    unitCode: "EquipConfiguration",
                                                    callBack: res =>
                                                        res.success === true ? setFilter(pv => ({...pv, prodObj: res.outParameters.out_CODE})) : null
                                                });
                                            }}
                                            edge="end"
                                        >
                                            <Icon>list</Icon>
                                        </IconButton>
                                    </InputAdornment>
                                }
                                aria-describedby="prodObj-outlined-helper-text"
                                label="Производственный объект"
                            />
                            {filter.prodObj ? null : <FormHelperText id="prodObj-outlined-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                        </FormControl>
                    </Box>
                    <Box component="section" sx = {{p: 1 }}>
                        <FormControl readOnly fullWidth>
                            <InputLabel htmlFor="techServ-outlined">Техническая служба</InputLabel>
                            <OutlinedInput
                                id="techServ-outlined"
                                value={filter.techServ}
                                endAdornment={
                                    <InputAdornment position="end">
                                        <IconButton
                                            aria-label="techServ select"
                                            onClick={() => {
                                                pOnlineShowDictionary({
                                                    unitCode: "INS_DEPARTMENT",
                                                    callBack: res =>
                                                        res.success === true ? setFilter(pv => ({...pv, techServ: res.outParameters.out_CODE})) : null
                                                });
                                            }}
                                            edge="end"
                                        >
                                            <Icon>list</Icon>
                                        </IconButton>
                                    </InputAdornment>
                                }
                                label="Техническая служба"
                            />
                        </FormControl>
                    </Box>
                    <Box component="section" sx = {{p: 1 }}>
                        <FormControl readOnly fullWidth>
                            <InputLabel htmlFor="respDep-outlined">Ответственное подразделение</InputLabel>
                            <OutlinedInput
                                id="respDep-outlined"
                                value={filter.respDep}
                                endAdornment={
                                    <InputAdornment position="end">
                                        <IconButton
                                            aria-label="respDep select"
                                            onClick={() => {
                                                pOnlineShowDictionary({
                                                    unitCode: "INS_DEPARTMENT",
                                                    callBack: res =>
                                                        res.success === true ? setFilter(pv => ({...pv, respDep: res.outParameters.out_CODE})) : null
                                                });
                                            }}
                                            edge="end"
                                        >
                                            <Icon>list</Icon>
                                        </IconButton>
                                    </InputAdornment>
                                }
                                label="Ответственное подразделение"
                            />
                        </FormControl>
                    </Box>
                    <Box component="section" sx = {{p: 1 }}>
                        <Grid container spacing={2}>
                            <Grid textAlign={"center"} item xs={4}>
                                Начало периода:
                            </Grid>
                            <Grid item xs={4}>
                                <FormControl fullWidth>
                                    <InputLabel id="from-month-select-label">Месяц</InputLabel>
                                    <Select
                                        error={filter.fromMonth ? false : true}
                                        labelId="from-month-select-label"
                                        id="from-month-select"
                                        value={filter.fromMonth}
                                        aria-describedby="from-month-select-helper-text"
                                        label="Месяц"
                                        onChange={e => setFilter(pv => ({ ...pv, fromMonth: e.target.value }))}
                                    >
                                        {monthArray.map((item, i) => (
                                            <MenuItem key={i + 1} value={i + 1}>
                                                {item}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                    {filter.fromMonth ? null : <FormHelperText id="from-month-select-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                                </FormControl>
                            </Grid>
                            <Grid item xs={4}>
                                <FormControl fullWidth>
                                    <InputLabel id="from-year-select-label">Год</InputLabel>
                                    <Select
                                        error={filter.fromYear ? false : true}
                                        labelId="from-year-select-label"
                                        id="from-year-select"
                                        value={filter.fromYear}
                                        aria-describedby="from-year-select-helper-text"
                                        label="Год"
                                        onChange={e => setFilter(pv => ({ ...pv, fromYear: e.target.value }))}
                                    >
                                        {yearArray.map((item, i) => (
                                            <MenuItem key={i} value={item}>
                                                {item}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                    {filter.fromYear ? null : <FormHelperText id="from-year-select-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                                </FormControl>
                            </Grid>
                        </Grid>
                    </Box>
                    <Box component="section" sx = {{p: 1 }}>
                        <Grid container spacing={2}> 
                            <Grid textAlign={"center"} item xs={4}>
                                Конец периода:
                            </Grid>                      
                            <Grid item xs={4}>
                                <FormControl fullWidth>
                                    <InputLabel id="to-month-select-label">Месяц</InputLabel>
                                    <Select
                                        error={filter.toMonth ? false : true}
                                        labelId="to-month-select-label"
                                        id="to-month-select"
                                        value={filter.toMonth}
                                        aria-describedby="to-month-select-helper-text"
                                        label="Месяц"
                                        onChange={e => setFilter(pv => ({ ...pv, toMonth: e.target.value }))}
                                    >
                                        {monthArray.map((item, i) => (
                                            <MenuItem key={i + 1} value={i + 1}>
                                                {item}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                    {filter.toMonth ? null : <FormHelperText id="to-month-select-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                                </FormControl>
                            </Grid>
                            <Grid item xs={4}>
                                <FormControl fullWidth>
                                    <InputLabel id="to-year-select-label">Год</InputLabel>
                                    <Select
                                        error={filter.toYear ? false : true}
                                        labelId="to-year-select-label"
                                        id="to-year-select"
                                        value={filter.toYear}
                                        aria-describedby="to-year-select-helper-text"
                                        label="Год"
                                        onChange={e => setFilter(pv => ({ ...pv, toYear: e.target.value }))}
                                    >
                                        {yearArray.map((item, i) => (
                                            <MenuItem key={i} value={item}>
                                                {item}
                                            </MenuItem>
                                        ))}
                                    </Select>
                                    {filter.toYear ? null : <FormHelperText id="to-year-select-helper-text" sx={{color: "red"}}>*Обязательное поле</FormHelperText>}
                                </FormControl>
                            </Grid>
                        </Grid>
                    </Box>
                </Paper>
            </DialogContent>
            <DialogActions>
                <Button variant="contained" disabled={filter.belong && filter.prodObj && filter.fromMonth && filter.fromYear 
                    && filter.toMonth && filter.toYear ? false : true} onClick={() => { setFilterLock(true); setDataGrid({reload: true}); closeFilter(); }}>Сформировать отчёт</Button>
                <Button variant="contained" onClick={clearFilter}>Очистить фильтр</Button>
                <Button variant="contained" onClick={() => {setFilter(filterCopy)}}>Отменить изменения</Button>             
            </DialogActions>
        </Dialog>
            <Link component="button" variant="body2" textAlign={"left"} onClick={openFilter}> 
                Фильтр отбора: {filter.belong ? `Принадлежность: ${filter.belong}` : ""} {filter.prodObj ? `Производственный объект: ${filter.prodObj}` : ""} {filter.techServ ? `Техническая служба: ${filter.techServ}` : ""} {filter.respDep ? `Ответственное подразделение: ${filter.respDep}` : ""} {filter.fromMonth && filter.fromYear ? `Начало периода: ${filter.fromMonth < 10 ? "0" + filter.fromMonth : filter.fromMonth}.${filter.fromYear}` : ""} {filter.toMonth && filter.toYear ? `Конец периода: ${filter.toMonth < 10 ? "0" + filter.toMonth : filter.toMonth}.${filter.toYear}` : ""}
            </Link>            
            {dataGrid.dataLoaded ? (
                <Paper variant="outlined">
                <Grid container spacing={1}>
                    <Grid item xs={12}>
                        <Box p={1}>
                        <P8PDataGrid
                            {...P8P_DATA_GRID_CONFIG_PROPS}
                            columnsDef={dataGrid.columnsDef}
                            groups={dataGrid.groups}
                            rows={dataGrid.rows}
                            size={P8P_DATA_GRID_SIZE.LARGE}
                            reloading={dataGrid.reload}
                            headCellRender={prms => headCellRender({ ...prms }, 
                                                                    filter.techServ,
                                                                    info.cntP,
                                                                    info.sumP,
                                                                    info.cntF,
                                                                    info.sumF)}
                            dataCellRender={prms => dataCellRender({ ...prms })}
                            groupCellRender={prms => groupCellRender({ ...prms })}
                            showCellRightBorder={true}
                        />
                        </Box>
                    </Grid>
                </Grid>
            </Paper>
            ) : null}
        </div>
    );
};

//----------------
//Интерфейс модуля
//----------------

export { EqsPrfrm };

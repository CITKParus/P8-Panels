/*
    Парус 8 - Панели мониторинга - Примеры для разработчиков
    Пример: Графики "P8PChart"
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useContext, useCallback, useEffect } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Typography, Grid, Paper } from "@mui/material"; //Интерфейсные элементы
import { P8PChart } from "../../components/p8p_chart"; //График
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { ApplicationСtx } from "../../context/application"; //Контекст приложения

//---------
//Константы
//---------

//Стили
const STYLES = {
    CONTAINER: { textAlign: "center", paddingTop: "20px" },
    TITLE: { paddingBottom: "15px" },
    CHART: { minWidth: "65vw", maxHeight: "65vw", display: "flex", justifyContent: "center" },
    CHART_PAPER: { padding: "25px" }
};

//-----------
//Тело модуля
//-----------

//Пример: Графики "P8PChart"
const Chart = ({ title }) => {
    //Собственное состояние - график
    const [chart, setChart] = useState({ loaded: false, labels: [], datasets: [] });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //Подключение к контексту приложения
    const { pOnlineShowUnit } = useContext(ApplicationСtx);

    //Загрузка данных графика с сервера
    const loadChart = useCallback(async () => {
        const chart = await executeStored({ stored: "PKG_P8PANELS_SAMPLES.CHART", respArg: "COUT" });
        setChart(pv => ({ ...pv, loaded: true, ...chart.XCHART }));
    }, [executeStored]);

    //Отработка нажатия на график
    const handleChartClick = ({ item }) => {
        pOnlineShowUnit({
            unitCode: "Contracts",
            inputParameters: [{ name: item.SCOND, value: item.SCOND_VALUE }]
        });
    };

    //При подключении к странице
    useEffect(() => {
        loadChart();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    //Генерация содержимого
    return (
        <div style={STYLES.CONTAINER}>
            <Typography sx={STYLES.TITLE} variant={"h6"}>
                {title}
            </Typography>
            <Grid container spacing={0} pt={5} direction="column" alignItems="center">
                <Grid item xs={12}>
                    <Paper elevation={6} sx={STYLES.CHART_PAPER}>
                        {chart.loaded ? <P8PChart {...chart} onClick={handleChartClick} style={STYLES.CHART} /> : null}
                    </Paper>
                </Grid>
            </Grid>
        </div>
    );
};

//Контроль свойств - Пример: Графики "P8PChart"
Chart.propTypes = {
    title: PropTypes.string.isRequired
};

//----------------
//Интерфейс модуля
//----------------

export { Chart };

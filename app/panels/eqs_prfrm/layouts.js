/*
    Парус 8 - 
    Дополнительная разметка и вёрстка клиентских элементов
*/

//---------------------
//Подключение библиотек
//---------------------

import { Grid, Stack } from "@mui/material";
import React from "react"; //Классы React

//---------
//Константы
//---------

//Шаблон чисел и имён ячеек дат
export const DIGITS_REG_EXP = /\d+,?\d*/g;
export const MONTH_NAME_REG_EXP = /_\d{4}_\d{1,2}/;
export const DAY_NAME_REG_EXP = /_\d{4}_\d{1,2}_\d{1,2}/;

let curParent = "";
let x = 0;

//-----------
//Тело модуля
//-----------
const formatDate = date => {
    const [year, month, day] = date.substring(1).split("_");
    let nd;
    if (day == null) nd = `${month < 10 ? "0" + month : month}.${year}`;
    else nd = `${day < 10 ? "0" + day : day}.${month < 10 ? "0" + month : month}.${year}`;
    return nd;
};

export const headCellRender = ({columnDef}, podr, cntP, sumP, cntF, sumF) => {
    let cellStyle = {border: "1px solid rgba(0, 0, 0)", textAlign: "center"};
    let cellProps = {};
    let data = columnDef.caption;
    
    if (columnDef.expandable)
    {
        // поменять расположение + для развёртывания
    }
    if (columnDef.name == "STEST")
        cellStyle = {display: "none"};
    if (columnDef.name == "SINFO" || columnDef.name == "SINFO2")
    {
        cellProps = { colSpan: 2 };
        if (columnDef.name == "SINFO") 
        {
            cellStyle = {...cellStyle, padding: "unset"};
            data = <Stack sx={{ justifyContent: "center" }} direction="row" width={300}>
                        <Grid container>
                            <Grid item xs={4}>
                                Подразделение:
                            </Grid>
                            <Grid item xs={8}>  
                                {podr}               
                            </Grid>
                            <Grid item xs={4}>
                                Кол-во ремонтов, план:
                            </Grid>
                            <Grid item xs={2}>  
                                {cntP}               
                            </Grid>
                            <Grid item xs={4}>
                                Трудоемкость, час. план:
                            </Grid>
                            <Grid item xs={2}>  
                                {sumP}               
                            </Grid>
                            <Grid item xs={4}>
                                Кол-во ремонтов, факт:
                            </Grid>
                            <Grid item xs={2}>  
                                {cntF}               
                            </Grid>
                            <Grid item xs={4}>
                                Трудоемкость, час. факт:
                            </Grid>
                            <Grid item xs={2}>  
                                {sumF}               
                            </Grid>
                        </Grid>
                    </Stack>
        }
    }
    
    if (columnDef.visible && DAY_NAME_REG_EXP.test(columnDef.name)) 
    {
        cellStyle = {...cellStyle, 
                     paddingLeft: "5px", 
                     paddingRight: "5px",
                     minWidth: "25px",
                     maxWidth: "25px"}
    }

    return {cellStyle, cellProps, data};
};

export const dataCellRender = ({ row, columnDef }) => {
    let cellStyle = {
        padding: "2px",
        border: "1px solid rgba(0, 0, 0)",
        textAlign: "center"
    };
    let cellProps = {};
    let data = " ";

    if (row["SINFO2"] == undefined) {
        if (columnDef.name == "STEST") cellProps = { colSpan: 2 };
        if (columnDef.name == "SINFO2") cellStyle = { display: "none" };
        if (columnDef.parent == "" && columnDef.expandable == true && columnDef.expanded == false) {
            curParent = columnDef.name;
            return { cellStyle: { ...cellStyle, height: "25px" }, data };
        } else if (columnDef.name != "SINFO2" && columnDef.parent != "" && columnDef.expandable == false && columnDef.expanded == true) {
            if (columnDef.name.endsWith("_1")) {
                curParent = columnDef.parent;
                const [year, month] = curParent.substring(1).split("_");
                x = new Date(year, month, 0).getDate();
                cellProps = { colSpan: x };
                data = row[curParent];
                return { cellStyle, cellProps, data };
            } else {
                cellStyle = { display: "none" };
            }
        }
    }
    if (columnDef.name == "STEST" && row["SINFO2"] == "План") {
        cellStyle = { ...cellStyle };
        cellProps = { rowSpan: 2 };
    }
    if (columnDef.name == "STEST" && row["SINFO2"] == "Факт") {
        cellStyle = { display: "none" };
    }

    switch (row[columnDef.name]) {
        case "blue":
            cellStyle = { ...cellStyle, backgroundColor: "royalblue", border: "1px solid rgba(0, 0, 0)" };
            cellProps = { title: formatDate(columnDef.name) };
            return { cellStyle, cellProps, data };
        case "green":
            cellStyle = { ...cellStyle, backgroundColor: "lawngreen", border: "1px solid rgba(0, 0, 0)" };
            cellProps = { title: formatDate(columnDef.name) };
            return { cellStyle, cellProps, data };
        case "red":
            cellStyle = { ...cellStyle, backgroundColor: "crimson", border: "1px solid rgba(0, 0, 0)" };
            cellProps = { title: formatDate(columnDef.name) };
            return { cellStyle, cellProps, data };
        case "green red":
        case "red green":
            cellStyle = {...cellStyle, padding: "unset"};
            cellProps = { title: formatDate(columnDef.name) };
            data = 
            <Stack sx={{ justifyContent: "center" }} direction="row">
                <Grid container maxHeight="100%">
                    <Grid item xs={6} sx={{backgroundColor: "lawngreen"}}>
                        <p style={{display: "none"}}>g</p>
                    </Grid>
                    <Grid item xs={6} sx={{backgroundColor: "crimson"}}>  
                        <p style={{display: "none"}}>r</p>                
                    </Grid>
                </Grid>
            </Stack> 
    }
    return { cellStyle, cellProps };
};

export const groupCellRender = () => {
    let cellStyle = { display: "none" };
    return { cellStyle };
};

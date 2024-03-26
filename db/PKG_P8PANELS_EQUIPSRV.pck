create or replace package PKG_P8PANELS_EQUIPSRV as

  /* Получение значения системного параметра "JuridicalPerson" */
  procedure GET_JUR_PERS_PRM
  (
    CRES                    out clob                               -- Значение параметра "JuridicalPerson" (null - если не нашли)
  );
  
  function HOURS_STR
  (
    NHOURS                  in number        -- Кол-во часов
  ) return                  varchar2;
  
  /* Выполнение работ по ТОиР */
  procedure EQUIPSRV_GRID
  (
    SBELONG                 in varchar2,                           -- Принадлежность к Юр. лицу
    SPRODOBJ                in varchar2,                           -- Производственный объект
    STECHSERV               in varchar2,                           -- Техническая служба
    SRESPDEP                in varchar2,                           -- Ответственное подразделение
    NFROMMONTH              in number,                             -- Месяц начала периода
    NFROMYEAR               in number,                             -- Год начала периода
    NTOMONTH                in number,                             -- Месяц окончания периода
    NTOYEAR                 in number,                             -- Год окончания периода
    COUT                    out clob                               -- График проектов
  );
end PKG_P8PANELS_EQUIPSRV;
/
create or replace package body PKG_P8PANELS_EQUIPSRV as
  
  /* Получение значения системного параметра "JuridicalPerson" */
  procedure GET_JUR_PERS_PRM
  (
    CRES                    out clob                               -- Значение параметра "JuridicalPerson" (null - если не нашли)
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Рег. номер организации
    SPARAMCODE              PKG_STD.TSTRING := 'JuridicalPerson';  -- Код параметра
  begin
    CRES := GET_OPTIONS_STR(SCODE      => SPARAMCODE,
                            NCOMP_VERS => NCOMPANY);
    if (CRES is null) then
      P_EXCEPTION(0, 'Пользовательский параметр не указан.');
    end if;                       
  end GET_JUR_PERS_PRM;
  
  /* Формирование строки с кол-вом часов */
  function HOURS_STR
  (
    NHOURS                  in number        -- Кол-во часов
  ) return                  varchar2         -- Строка с кол-вом часов
  is
    SRESULT                 PKG_STD.tSTRING; -- Строка результат
  begin
    if (MOD(NHOURS, 10) = 1 and MOD(NHOURS, 100) != 11) then
      SRESULT := NHOURS || ' час';
    elsif ((MOD(NHOURS, 10) = 2 and MOD(NHOURS, 100) != 12)
        or (MOD(NHOURS, 10) = 3 and MOD(NHOURS, 100) != 13)
        or (MOD(NHOURS, 10) = 4 and MOD(NHOURS, 100) != 14)) then
      SRESULT := NHOURS || ' часа';
    else
      SRESULT := NHOURS || ' часов';
    end if;
    /* Возвращаем результат */
    return SRESULT;
  end HOURS_STR;

  /* Выполнение работ по ТОиР */
  procedure EQUIPSRV_GRID
  (
    SBELONG                 in varchar2,                           -- Принадлежность к Юр. лицу
    SPRODOBJ                in varchar2,                           -- Производственный объект
    STECHSERV               in varchar2,                           -- Техническая служба
    SRESPDEP                in varchar2,                           -- Ответственное подразделение
    NFROMMONTH              in number,                             -- Месяц начала периода
    NFROMYEAR               in number,                             -- Год начала периода
    NTOMONTH                in number,                             -- Месяц окончания периода
    NTOYEAR                 in number,                             -- Год окончания периода
    COUT                    out clob                               -- График проектов
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Рег. номер организации
    SPRJ_GROUP_NAME         PKG_STD.TSTRING;                       -- Наименование группы для проекта
    BEXPANDED               boolean;                               -- Флаг раскрытости уровня
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW0                PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы0
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    RDG_ROW2                PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы2
    NCURYEAR                PKG_STD.tNUMBER;                       -- Текущий год
    NCURMONTH               PKG_STD.tNUMBER;                       -- Текущий месяц
    NTOTALDAYS              PKG_STD.tNUMBER;                       -- Дней в текущем месяце
    SCURTECHOBJ             PKG_STD.TSTRING := null;               -- Текущий технический объект
    SCURTSKCODE             PKG_STD.TSTRING := null;               -- Текущий вид ремонта
    NFROMDATE               date := TO_DATE('01.' 
                            || LPAD(TO_CHAR(NFROMMONTH), 2, '0') 
                            || '.' || TO_CHAR(NFROMYEAR),
                            'dd.mm.yyyy');                         -- Дата начала периода
    NTODATE                 date := LAST_DAY(TO_DATE('01.' 
                            || LPAD(TO_CHAR(NTOMONTH), 2, '0') 
                            || '.' || TO_CHAR(NTOYEAR), 
                            'dd.mm.yyyy'));                        -- Дата конца периода
    NMS                     PKG_STD.tNUMBER;                       -- Месяц начала в цикле года
    NME                     PKG_STD.tNUMBER;                       -- Месяц окончания в цикле года
    NYEAR_PLAN              PKG_STD.tNUMBER;                       -- Год план
    NMONTH_PLAN             PKG_STD.tNUMBER;                       -- Месяц план
    NDAY_PLAN               PKG_STD.tNUMBER;                       -- День план
    NYEAR_FACT              PKG_STD.tNUMBER;                       -- Год факт
    NMONTH_FACT             PKG_STD.tNUMBER;                       -- Месяц факт
    NDAY_FACT               PKG_STD.tNUMBER;                       -- День факт
    SPERIODNAME             PKG_STD.TSTRING;                       -- Имя периода
    SFACT_CLR               PKG_STD.TSTRING;                       -- Цвет закрашивания фактических дат
    NROWS                   PKG_STD.tNUMBER := 0;                  -- Кол-во строк в курсоре   
    NWORKPERDAY             PKG_STD.tNUMBER(17,2) := null;         -- Работы в день 
    CR                      PKG_STD.TSTRING;    
    SGROUP_FILLED           PKG_STD.tLSTRING;                      -- Группы, заполненные строками план/факт
    SCOLS                   PKG_STD.tLSTRING;                      -- Заполнение периодов работ    
    YM                      PKG_CONTVALLOC1S.tCONTAINER;           -- Коллекция для подсчёта работ за месяц
    MCLR                    PKG_CONTVALLOC1S.tCONTAINER;           -- Коллекция для закрашивания месяцев
    
    cursor C1 is
           select TT.NEQV_RN, 
                  TT.NEQS_RN, 
                  TT.NWRK_RN NRN, 
                  TT.COMPANY NCOMPANY,
                  TT.NAME_WORK SWORKNAME,
                  EC2.CODE STECHOBJCODE,
                  EC2.NAME STECHOBJNAME,
                  JP.CODE SBELONG,
                  EC1.CODE SPRODOBJ,
                  DS.CODE STECHSERV,
                  DR.CODE SRESPDEP,
                  TT.DATEPRD_BEG DDATEPLANBEG,
                  TT.DATEPRD_END DDATEPLANEND,
                  EQJ.DATEFACT_BEG DDATEFACTBEG,
                  EQJ.DATEFACT_END DDATEFACTEND,
                  EK.CODE STECSRVKINDCODE,
                  EK.NAME STECSRVKINDNAME,
                  coalesce(EW.NSUM, 
                          (TT.DATEPRD_END - TT.DATEPRD_BEG) * 24) NSUMWORKPLAN,
                  coalesce(EWJ.NSUMF, 
                          (EQJ.DATEFACT_END - EQJ.DATEFACT_BEG) * 24) NSUMWORKFACT
             from 
                  (select B.*, 
                          C.RN nWRK_RN, 
                          C.PRN nWRK_PRN, 
                          C.NAME_WORK, 
                          C.DATEPLAN_BEG, 
                          C.DATEPLAN_END, 
                          C.TECSRVKIND, 
                          C.EQCONFIG, 
                          C.DEPTPERF, 
                          C.DEPTTCSRV, 
                          C.RESP_AGN 
                     from (select EQV.RN nEQV_RN, 
                                  EQV.COMPANY, 
                                  EQV.JUR_PERS, 
                                  EQV.STATE, 
                                  EQV.DATEPRD_BEG, 
                                  EQV.DATEPRD_END, 
                                  EQS.RN nEQS_RN
                             from EQTCHSRV EQV,    -- Графики ТОиР
                                  DOCLINKS DL, 
                                  EQRPSHEETS EQS   -- Ремонтные ведомости
                            where EQV.RN = DL.IN_DOCUMENT (+)
                              and DL.OUT_UNITCODE (+) = 'EquipRepairSheets' 
                              and DL.OUT_DOCUMENT = EQS.RN (+)) B,
                          EQTCHSRWRK C
                    where B.nEQV_RN = C.PRN (+) 
                    union all
                   select B.*, 
                          C.RN nWRK_RN, 
                          C.PRN nWRK_PRN, 
                          C.NAME_WORK, 
                          C.DATEPLAN_BEG, 
                          C.DATEPLAN_END, 
                          C.TECSRVKIND, 
                          C.EQCONFIG, 
                          C.DEPTPERF, 
                          null DEPTTCSRV, 
                          C.RESP_AGN 
                     from (select null nEQV_RN, 
                                  EQS.COMPANY, 
                                  EQS.JURPERSONS JUR_PERS, 
                                  EQS.STATE, 
                                  EQS.DATEPLAN_BEG, 
                                  EQS.DATEPLAN_END, 
                                  EQS.RN nEQS_RN
                             from EQRPSHEETS EQS   -- Ремонтные ведомости
                            where not exists (select 1 
                                                from DOCLINKS DL 
                                               where DL.OUT_DOCUMENT = EQS.RN 
                                                 and DL.IN_UNITCODE = 'EquipTechServices')) B,
                          EQRPSHWRK C
                    where B.nEQS_RN = C.PRN (+)) TT,                 
                  EQTECSRVKIND EK,
                  JURPERSONS JP,
                  EQCONFIG EC1,
                  EQCONFIG EC2,
                  INS_DEPARTMENT DS,
                  INS_DEPARTMENT DR,
                  DOCLINKS DL,
                  EQTECSRVJRNL EQJ,
                  (select t.prn, 
                          sum(t.Worktimeplan * t.perform_quant) NSUM 
                     from EQTCHSRWRC t 
                    group by t.prn) EW,
                  (select t.prn,  
                          sum(t.worktimefact * t.quantfact) NSUMF 
                     from EQTCHSRJRNLWRC t 
                    group by t.prn) EWJ                     
            where TT.COMPANY = NCOMPANY
              and ((TT.state in (1,2) and nEQV_RN is not null) or (TT.state in (0,2,3) and nEQV_RN is null))
              and TT.DATEPRD_BEG >= NFROMDATE
              and TT.DATEPRD_END <= NTODATE
              and JP.CODE = SBELONG
              and EC1.CODE = SPRODOBJ
              and (DS.CODE = STECHSERV or STECHSERV is null)
              and (DR.CODE = SRESPDEP or SRESPDEP is null)
              and TT.EQCONFIG = EC2.RN (+)
              and TT.DEPTPERF = DR.RN (+) 
              and TT.DEPTTCSRV = DS.RN (+)          
              and TT.NWRK_RN = EW.PRN (+)
              and EQJ.RN = EWJ.PRN (+)                 
              and TT.TECSRVKIND = EK.RN (+)
              and TT.NWRK_RN = DL.IN_DOCUMENT (+)
              and ((DL.OUT_UNITCODE = 'EquipTechServiceJournal' and DL.RN is not null) or (DL.OUT_UNITCODE is null and DL.RN is null))
              and DL.OUT_DOCUMENT = EQJ.RN (+)                 
            order by EC2.NAME, EK.CODE;
  begin
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Формируем структуру заголовка */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STEST',
                                               SCAPTION   => 'ТЕСТ', 
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SINFO',
                                               SCAPTION   => 'Информация', 
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SINFO2',
                                               SCAPTION   => 'Объект ремонта',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SPARENT    => 'SINFO');                                           
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SWORKNAME',
                                               SCAPTION   => 'Наименование работы',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECHOBJCODE',
                                               SCAPTION   => 'Код тех. объекта',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECHOBJNAME',
                                               SCAPTION   => 'Наименование тех. объекта',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SBELONG',
                                               SCAPTION   => 'Принадлежность',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPRODOBJ',
                                               SCAPTION   => 'Производственный объект',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECHSERV',
                                               SCAPTION   => 'Тех. служба',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SRESPDEP',
                                               SCAPTION   => 'Отвественное подразделение',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECSERVCODE',
                                               SCAPTION   => 'Вид ремонта',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDATEPLANBEG',
                                               SCAPTION   => 'Начало работы (план)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDATEPLANEND',
                                               SCAPTION   => 'Окончание работы (план)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDATEFACTBEG',
                                               SCAPTION   => 'Начало работы (факт)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDATEFACTEND',
                                               SCAPTION   => 'Окончание работы (факт)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECSRVKINDCODE',
                                               SCAPTION   => 'Код типа работы',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'STECSRVKINDNAME',
                                               SCAPTION   => 'Наименование типа работы',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);                                          
    /* Очистка коллекций */                                           
    PKG_CONTVALLOC1S.PURGE(YM);
    PKG_CONTVALLOC1S.PURGE(MCLR);                             

    NCURYEAR := EXTRACT(year from sysdate);
    NCURMONTH := EXTRACT(month from sysdate); 
    
    /* Цикл по годам периода */                                           
    for Y in NFROMYEAR .. NTOYEAR
    loop
      if (NFROMYEAR = NTOYEAR) then
        NMS := NFROMMONTH;
        NME := NTOMONTH;
      else
        if (Y = NFROMYEAR) then
          NMS := NFROMMONTH;
          NME := 12;
        elsif (NFROMYEAR < Y and Y < NTOYEAR) then
          NMS := 1;
          NME := 12;
        elsif (Y = NTOYEAR) then
          NMS := 1;
          NME := NTOMONTH;     
        end if;
      end if;
      
      /* Цикл по месяцам года */
      for M in NMS .. NME
      loop
        
        PKG_CONTVALLOC1S.PUTN(YM, '_' || TO_CHAR(Y) || '_' || TO_CHAR(M) || '_P', 0);       
        PKG_CONTVALLOC1S.PUTN(YM, '_' || TO_CHAR(Y) || '_' || TO_CHAR(M) || '_F', 0);
      
        if (Y = NCURYEAR and M = NCURMONTH) then
          BEXPANDED := true;
        else
          BEXPANDED := false;
        end if;
        
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                   SNAME      => '_' || TO_CHAR(Y) || '_' || TO_CHAR(M),
                                                   SCAPTION   => LPAD(TO_CHAR(M), 2, '0') || ' ' || TO_CHAR(Y),
                                                   SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                                   BEXPANDABLE => true,
                                                   BEXPANDED   => BEXPANDED);                                           
        NTOTALDAYS := to_number(to_char(LAST_DAY(TO_DATE('01.' || LPAD(TO_CHAR(M), 2, '0') || '.' || TO_CHAR(Y), 'dd.mm.yyyy')),'dd'), '99'); 
        /* Цикл по дням месяца */
        for D in 1 .. NTOTALDAYS
        loop
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                     SNAME      => '_' || TO_CHAR(Y) || '_' || TO_CHAR(M) || '_' || TO_CHAR(D),
                                                     SCAPTION   => TO_CHAR(D, '99'),
                                                     SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                                     SPARENT    => '_' || TO_CHAR(Y) || '_' || TO_CHAR(M));
        end loop;
      end loop;      
    end loop;
    
    /* Подсчёт кол-ва записей в курсоре */                                                                                  
    for Q1 in C1
    loop
      NROWS := NROWS + 1;
    end loop;
    
    /* Цикл по курсору */
    for QQ in C1
    loop
      NROWS := NROWS - 1;
      if (SCURTECHOBJ != QQ.STECHOBJNAME or SCURTECHOBJ is null) then       
        if (RDG_ROW0.RCOLS is not null) then
          /* Цикл по годам периода */                                           
          for Y in NFROMYEAR .. NTOYEAR
          loop
            if (NFROMYEAR = NTOYEAR) then
              NMS := NFROMMONTH;
              NME := NTOMONTH;
            else
              if (Y = NFROMYEAR) then
                NMS := NFROMMONTH;
                NME := 12;
              elsif (NFROMYEAR < Y and Y < NTOYEAR) then
                NMS := 1;
                NME := 12;
              elsif (Y = NTOYEAR) then
                NMS := 1;
                NME := NTOMONTH;     
              end if;
            end if;
            
            /* Цикл по месяцам года */
            for M in NMS .. NME
            loop
              SPERIODNAME := '_' || TO_CHAR(Y) || '_' || TO_CHAR(M);
              PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW0, 
                                               SNAME => SPERIODNAME, 
                                               SVALUE => 'план: ' || HOURS_STR(PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_P')) || ' факт: ' || HOURS_STR(PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_F')));
              PKG_CONTVALLOC1S.PUTN(YM, SPERIODNAME || '_P', 0);       
              PKG_CONTVALLOC1S.PUTN(YM, SPERIODNAME || '_F', 0);
            end loop;      
          end loop;
           
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW0);
        end if;
        SCURTECHOBJ := QQ.STECHOBJNAME;
        SPRJ_GROUP_NAME := SCURTECHOBJ;
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_GROUP(RDATA_GRID  => RDG,
                                                 SNAME       => SPRJ_GROUP_NAME,
                                                 SCAPTION    => QQ.STECHOBJNAME,
                                                 BEXPANDABLE => false);                                        
        RDG_ROW0 := PKG_P8PANELS_VISUAL.TROW_MAKE(SGROUP => SPRJ_GROUP_NAME);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW0, SNAME => 'STEST', SVALUE => SCURTECHOBJ);                                
      end if;
      /* Формируем имя группы для вида ремонта */
      SCURTSKCODE := SCURTECHOBJ || '_' || QQ.STECSRVKINDCODE;
      /* Если по данной группе еще нет строк плана и факта */
      if (STRIN(sSUBSTR => SCURTSKCODE, sSOURCE => SGROUP_FILLED, sDELIM => ';') = 0) then
        /* Добавляем строку плана */
        if (RDG_ROW.RCOLS is not null) then
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end if;
        /* Добавляем строку факта */
        if (RDG_ROW2.RCOLS is not null) then
          CR := PKG_CONTVALLOC1S.FIRST_(MCLR);
          /* Цикл по коллекции для закрашивания месяцев */
          for Z in 1 .. PKG_CONTVALLOC1S.COUNT_(MCLR)
          loop
            PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW2, SNAME => CR, SVALUE => PKG_CONTVALLOC1S.GETS(MCLR, CR));
            CR := PKG_CONTVALLOC1S.NEXT_(MCLR, CR);
          end loop;
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW2);
        end if;
        PKG_CONTVALLOC1S.PURGE(MCLR);
        /* Добвим группу для вида ремонта */
        SPRJ_GROUP_NAME := SCURTSKCODE;
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_GROUP(RDATA_GRID  => RDG,
                                                 SNAME       => SPRJ_GROUP_NAME,
                                                 SCAPTION    => QQ.STECSRVKINDCODE,
                                                 BEXPANDABLE => false);
        RDG_ROW := PKG_P8PANELS_VISUAL.TROW_MAKE(SGROUP => SPRJ_GROUP_NAME); 
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'STEST', SVALUE => QQ.STECSRVKINDCODE);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'SINFO2', SVALUE => 'План');       
        RDG_ROW2 := PKG_P8PANELS_VISUAL.TROW_MAKE(SGROUP => SPRJ_GROUP_NAME); 
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW2, SNAME => 'SINFO2', SVALUE => 'Факт');
        /* Добавляем в заполненные группы */
        SGROUP_FILLED := SGROUP_FILLED || SPRJ_GROUP_NAME || ';';
                                                  
      end if;
      /* Плановые работы */
      if (QQ.NEQV_RN is not null) then
        for x in 0 .. trunc(QQ.DDATEPLANEND) - trunc(QQ.DDATEPLANBEG)
        loop
          NYEAR_PLAN := EXTRACT(year from QQ.DDATEPLANBEG + x); 
          NMONTH_PLAN := EXTRACT(month from QQ.DDATEPLANBEG + x);
          NDAY_PLAN := EXTRACT(day from QQ.DDATEPLANBEG + x);
            
          if (x = 0) then
            SPERIODNAME := '_' || TO_CHAR(NYEAR_PLAN) || '_' || NMONTH_PLAN;
              
            if (QQ.NSUMWORKPLAN is not null) then
              PKG_CONTVALLOC1S.PUTN(YM, SPERIODNAME || '_P', PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_P') + QQ.NSUMWORKPLAN);
            end if;

            if (STRIN(sSUBSTR => SPRJ_GROUP_NAME || ' ' || SPERIODNAME || ' PLAN', sSOURCE => SCOLS, sDELIM => ';') = 0) then
              PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => SPERIODNAME, SVALUE => 'blue');
              SCOLS := SCOLS || SPRJ_GROUP_NAME || ' ' || SPERIODNAME || ' PLAN;'; 
            end if;
          end if;
          SPERIODNAME := '_' || TO_CHAR(NYEAR_PLAN) || '_' || TO_CHAR(NMONTH_PLAN) || '_' || TO_CHAR(NDAY_PLAN);
          if (STRIN(sSUBSTR => SPRJ_GROUP_NAME || ' ' || SPERIODNAME || ' PLAN', sSOURCE => SCOLS, sDELIM => ';') = 0) then
            PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => SPERIODNAME, SVALUE => 'blue');
            SCOLS := SCOLS || SPRJ_GROUP_NAME || ' ' || SPERIODNAME || ' PLAN;'; 
          end if;        
        end loop;
      end if;
      
      /* Фактические и внеплановые работы */
      if (QQ.DDATEFACTEND is not null and QQ.DDATEFACTBEG is not null) then
        if (QQ.nEQV_RN is not null) then
          SFACT_CLR := 'green';
        else
          SFACT_CLR := 'red';
        end if;   
        
        NWORKPERDAY := null;
        if (EXTRACT(month from QQ.DDATEFACTBEG) != EXTRACT(month from QQ.DDATEFACTEND)) then
          NWORKPERDAY := QQ.NSUMWORKFACT/(round(QQ.DDATEFACTEND - QQ.DDATEFACTBEG) + 1);
          NCURMONTH := EXTRACT(month from QQ.DDATEFACTBEG);
        end if; 
        
        for x in 0 .. trunc(QQ.DDATEFACTEND) - trunc(QQ.DDATEFACTBEG)
        loop
          NYEAR_FACT := EXTRACT(year from QQ.DDATEFACTBEG + x); 
          NMONTH_FACT := EXTRACT(month from QQ.DDATEFACTBEG + x);
          NDAY_FACT := EXTRACT(day from QQ.DDATEFACTBEG + x);
            
          if (x = 0 or NCURMONTH != NMONTH_FACT) then
            if (NCURMONTH != NMONTH_FACT) then
              NCURMONTH := NMONTH_FACT;
            end if;
            SPERIODNAME := '_' || TO_CHAR(NYEAR_FACT) || '_' || NMONTH_FACT;
              
            if (QQ.NSUMWORKFACT is not null and NWORKPERDAY is null) then          
              PKG_CONTVALLOC1S.PUTN(YM, SPERIODNAME || '_F', PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_F') + QQ.NSUMWORKFACT);
            end if;
            
            /* Добавление в коллекцию окрашивания месяца */
            if (PKG_CONTVALLOC1S.EXISTS_(rCONTAINER => MCLR, sROWID => SPERIODNAME) = false) then
              PKG_CONTVALLOC1S.PUTS(MCLR, SPERIODNAME, SFACT_CLR);
            else
              if (STRIN(trim(SFACT_CLR), trim(PKG_CONTVALLOC1S.GETS(MCLR, SPERIODNAME))) = 0) then
                PKG_CONTVALLOC1S.PUTS(MCLR, SPERIODNAME, PKG_CONTVALLOC1S.GETS(MCLR, SPERIODNAME) || ' ' || SFACT_CLR);
              end if;
            end if;
          end if;
          if (NWORKPERDAY is not null) then
            PKG_CONTVALLOC1S.PUTN(YM, SPERIODNAME || '_F', PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_F') + NWORKPERDAY);
          end if;
          SPERIODNAME := '_' || TO_CHAR(NYEAR_FACT) || '_' || TO_CHAR(NMONTH_FACT) || '_' || TO_CHAR(NDAY_FACT);
          /* Добавление окрашивания дней факта */
          if (PKG_CONTVALLOC1S.EXISTS_(rCONTAINER => MCLR, sROWID => SPERIODNAME) = false) then
            PKG_CONTVALLOC1S.PUTS(MCLR, SPERIODNAME, SFACT_CLR);
          else
            if (trim(PKG_CONTVALLOC1S.GETS(MCLR, SPERIODNAME)) = 'green' and trim(SFACT_CLR) = 'red') then
              PKG_CONTVALLOC1S.PUTS(MCLR, SPERIODNAME, SFACT_CLR);
            end if;
          end if;    
        end loop;
      end if;  
      
      if (RDG_ROW0.RCOLS is not null and NROWS = 0) then
        /* Цикл по годам периода */                                           
        for Y in NFROMYEAR .. NTOYEAR
        loop
          if (NFROMYEAR = NTOYEAR) then
            NMS := NFROMMONTH;
            NME := NTOMONTH;
          else
            if (Y = NFROMYEAR) then
              NMS := NFROMMONTH;
              NME := 12;
            elsif (NFROMYEAR < Y and Y < NTOYEAR) then
              NMS := 1;
              NME := 12;
            elsif (Y = NTOYEAR) then
              NMS := 1;
              NME := NTOMONTH;     
            end if;
          end if;
            
          /* Цикл по месяцам года */
          for M in NMS .. NME
          loop
            SPERIODNAME := '_' || TO_CHAR(Y) || '_' || TO_CHAR(M);
            PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW0, 
                                             SNAME => SPERIODNAME, 
                                             SVALUE => 'план: ' || HOURS_STR(PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_P')) || ' факт: ' || HOURS_STR(PKG_CONTVALLOC1S.GETN(YM, SPERIODNAME || '_F')));
          end loop;      
        end loop;
           
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW0);
      end if;
      /* План для последней записи */  
      if (RDG_ROW.RCOLS is not null and NROWS = 0) then
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end if;
      /* Факт для последней записи */
      if (RDG_ROW2.RCOLS is not null and NROWS = 0) then
        CR := PKG_CONTVALLOC1S.FIRST_(MCLR);
        for Z in 1 .. PKG_CONTVALLOC1S.COUNT_(MCLR)
        loop
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW2, SNAME => CR, SVALUE => PKG_CONTVALLOC1S.GETS(MCLR, CR));
          CR := PKG_CONTVALLOC1S.NEXT_(MCLR, cr);
        end loop;
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW2);
      end if;  
    end loop;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => 1);
    PKG_CONTVALLOC1S.PURGE(YM);
  end EQUIPSRV_GRID;
end PKG_P8PANELS_EQUIPSRV;
/

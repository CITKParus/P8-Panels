create or replace package PKG_P8PANELS_SAMPLES as

  /* Получение списка контрагентов */
  procedure AGNLIST_GET
  (
    COUT                    out clob    -- Список контрагентов
  );

  /* Добавление контрагента */
  procedure AGNLIST_INSERT
  (
    SAGNABBR                in varchar2, -- Мнемокод
    SAGNNAME                in varchar2, -- Наименование
    NRN                     out number   -- Рег. номер добавленного
  );

  /* Удаление контрагента */
  procedure AGNLIST_DELETE
  (
    NRN                     in number   -- Рег. номер удаляемого
  );
  
  /* Таблица данных */
  procedure DATA_GRID
  (
    NPAGE_NUMBER            in number, -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number, -- Количество записей на странице (0 - все)
    CFILTERS                in clob,   -- Фильтры
    CORDERS                 in clob,   -- Сортировки
    NINCLUDE_DEF            in number, -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob   -- Сериализованная таблица данных
  );

  /* График */
  procedure CHART
  (
    COUT                    out clob    -- Сериализованный график
  );

end PKG_P8PANELS_SAMPLES;
/
create or replace package body PKG_P8PANELS_SAMPLES as

  /* Получение списка контрагентов */
  procedure AGNLIST_GET
  (
    COUT                    out clob      -- Список контрагентов
  )
  is
    NVERSION                PKG_STD.TREF; -- Рег. номер версии словаря контрагентов
  begin
    NVERSION := GET_SESSION_VERSION(SUNITCODE => 'AGNLIST');
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    PKG_XFAST.DOWN_NODE(SNAME => 'DATA');
    for C in (select D.*
                from (select T.RN      NRN,
                             T.AGNABBR SAGNABBR,
                             T.AGNNAME SAGNNAME
                        from AGNLIST T
                       where T.VERSION = NVERSION
                         and exists (select /*+ INDEX(UP I_USERPRIV_CATALOG_ROLEID) */
                               null
                                from USERPRIV UP
                               where UP.CATALOG = T.CRN
                                 and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                                    UR.ROLEID
                                                     from USERROLES UR
                                                    where UR.AUTHID = UTILIZER)
                              union all
                              select /*+ INDEX(UP I_USERPRIV_CATALOG_AUTHID) */
                               null
                                from USERPRIV UP
                               where UP.CATALOG = T.CRN
                                 and UP.AUTHID = UTILIZER)
                       order by T.RN desc) D
               where ROWNUM <= 10)
    loop
      PKG_XFAST.DOWN_NODE(SNAME => 'AGENTS');
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => C.NRN);
      PKG_XFAST.ATTR(SNAME => 'SAGNABBR', SVALUE => C.SAGNABBR);
      PKG_XFAST.ATTR(SNAME => 'SAGNNAME', SVALUE => C.SAGNNAME);
      PKG_XFAST.UP();
    end loop;
    PKG_XFAST.UP();
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    PKG_XFAST.EPILOGUE();
  end AGNLIST_GET;

  /* Добавление контрагента */
  procedure AGNLIST_INSERT
  (
    SAGNABBR                in varchar2,                           -- Мнемокод
    SAGNNAME                in varchar2,                           -- Наименование
    NRN                     out number                             -- Рег. номер добавленного
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Текущая организация
    NCRN                    PKG_STD.TREF;                          -- Каталог размещения контрагента
  begin
    if (SAGNABBR is null) then
      P_EXCEPTION(0, 'Не указан мнемокод.');
    end if;
    if (SAGNABBR is null) then
      P_EXCEPTION(0, 'Не указано наименование.');
    end if;
    FIND_ROOT_CATALOG(NCOMPANY => NCOMPANY, SCODE => 'AGNLIST', NCRN => NCRN);
    P_AGNLIST_INSERT(NCOMPANY          => NCOMPANY,
                     CRN               => NCRN,
                     AGNABBR           => SAGNABBR,
                     AGNTYPE           => 0,
                     AGNNAME           => SAGNNAME,
                     AGNIDNUMB         => null,
                     ECONCODE          => null,
                     ORGCODE           => null,
                     AGNFAMILYNAME     => null,
                     AGNFIRSTNAME      => null,
                     AGNLASTNAME       => null,
                     AGNFAMILYNAME_TO  => null,
                     AGNFIRSTNAME_TO   => null,
                     AGNLASTNAME_TO    => null,
                     AGNFAMILYNAME_FR  => null,
                     AGNFIRSTNAME_FR   => null,
                     AGNLASTNAME_FR    => null,
                     AGNFAMILYNAME_AC  => null,
                     AGNFIRSTNAME_AC   => null,
                     AGNLASTNAME_AC    => null,
                     AGNFAMILYNAME_ABL => null,
                     AGNFIRSTNAME_ABL  => null,
                     AGNLASTNAME_ABL   => null,
                     EMP               => 0,
                     EMPPOST           => null,
                     EMPPOST_FROM      => null,
                     EMPPOST_TO        => null,
                     EMPPOST_AC        => null,
                     EMPPOST_ABL       => null,
                     AGNBURN           => null,
                     PHONE             => null,
                     PHONE2            => null,
                     FAX               => null,
                     TELEX             => null,
                     MAIL              => null,
                     IMAGE             => null,
                     DDISCDATE         => null,
                     AGN_COMMENT       => null,
                     NSEX              => 0,
                     SPENSION_NBR      => null,
                     SMEDPOLICY_SER    => null,
                     SMEDPOLICY_NUMB   => null,
                     SPROPFORM         => null,
                     SREASON_CODE      => null,
                     NRESIDENT_SIGN    => 0,
                     STAXPSTATUS       => null,
                     SOGRN             => null,
                     SPRFMLSTS         => null,
                     SPRNATION         => null,
                     SCITIZENSHIP      => null,
                     ADDR_BURN         => null,
                     SPRMLREL          => null,
                     SOKATO            => null,
                     SPFR_NAME         => null,
                     DPFR_FILL_DATE    => null,
                     DPFR_REG_DATE     => null,
                     SPFR_REG_NUMB     => null,
                     SFULLNAME         => null,
                     SOKFS             => null,
                     SOKOPF            => null,
                     STFOMS            => null,
                     SFSS_REG_NUMB     => null,
                     SFSS_SUBCODE      => null,
                     NCOEFFIC          => 0,
                     DAGNDEATH         => null,
                     NOLD_RN           => null,
                     SOKTMO            => null,
                     SINN_CITIZENSHIP  => null,
                     DTAX_REG_DATE     => null,
                     SORIGINAL_NAME    => null,
                     NIND_BUSINESSMAN  => 0,
                     SFNS_CODE         => null,
                     SCTZNSHP_TYPE     => null,
                     NCONTACT_METHOD   => null,
                     SMF_ID            => null,
                     SOKOGU            => null,
                     NRN               => NRN);
  end AGNLIST_INSERT;

  /* Удаление контрагента */
  procedure AGNLIST_DELETE
  (
    NRN                     in number   -- Рег. номер удаляемого
  )
  is
  begin
    P_AGNLIST_DELETE(NCOMPANY => GET_SESSION_COMPANY(), RN => NRN);
  end AGNLIST_DELETE;
  
  /* Таблица данных */
  procedure DATA_GRID
  (
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CFILTERS                in clob,                               -- Фильтры
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NIDENT                  PKG_STD.TREF := GEN_IDENT();           -- Идентификатор отбора
    RF                      PKG_P8PANELS_VISUAL.TFILTERS;          -- Фильтры
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RAGN_TYPES              PKG_P8PANELS_VISUAL.TCOL_VALS;         -- Предопределенные значения "Типа контрагентов"
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читаем фильтры */
    RF := PKG_P8PANELS_VISUAL.TFILTERS_FROM_XML(CFILTERS => CFILTERS);
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SAGNABBR',
                                               SCAPTION   => 'Мнемокод',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'AgentAbbr',
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SAGNNAME',
                                               SCAPTION   => 'Наименование',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'AgentName',
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RAGN_TYPES, NVALUE => 0);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RAGN_TYPES, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NAGNTYPE',
                                               SCAPTION   => 'Тип',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'AgentType',
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RAGN_TYPES,
                                               SHINT      => 'В Системе бывают контрагенты двух типов:<br>' ||
                                                             '<b style="color:blue">Юридическое лицо</b> - организация, которая имеет в собственности, хозяйственном ведении ' ||
                                                             'или оперативном управлении обособленное имущество, отвечает по своим обязательствам этим имуществом, может от своего ' ||
                                                             'имени приобретать и осуществлять имущественные и личные неимущественные права, отвечать по своим обязанностям.<br>' ||
                                                             '<b style="color:green">Физическое лицо</b> - субъект правовых отношений, представляющий собой одного человека.');
    /* Обходим данные */
    begin
      /* Собираем запрос */
      CSQL := 'select *
            from (select D.*,
                         ROWNUM NROW
                    from (select AG.AGNABBR SAGNABBR,
                                 AG.AGNNAME SAGNNAME,
                                 AG.AGNTYPE NAGNTYPE
                            from AGNLIST AG
                           where exists (select /*+ INDEX(UP I_USERPRIV_CATALOG_ROLEID) */ null from USERPRIV UP where UP.CATALOG = AG.CRN and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */ UR.ROLEID from USERROLES UR where UR.AUTHID = UTILIZER)
                                         union all
                                         select /*+ INDEX(UP I_USERPRIV_CATALOG_AUTHID) */ null from USERPRIV UP where UP.CATALOG = AG.CRN and UP.AUTHID = UTILIZER)
                             and AG.RN in (select ID from COND_BROKER_IDSMART where IDENT = :NIDENT) %ORDER_BY%) D) F
           where F.NROW between :NROW_FROM and :NROW_TO';
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Учтём фильтры */
      PKG_P8PANELS_VISUAL.TFILTERS_SET_QUERY(NIDENT     => NIDENT,
                                             NCOMPANY   => NCOMPANY,
                                             SUNIT      => 'AGNLIST',
                                             SPROCEDURE => 'P_AGNLIST_BASE_COND',
                                             RDATA_GRID => RDG,
                                             RFILTERS   => RF);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NIDENT', NVALUE => NIDENT);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 3);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SAGNABBR', ICURSOR => ICURSOR, NPOSITION => 1, BCLEAR => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SAGNNAME', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NAGNTYPE', ICURSOR => ICURSOR, NPOSITION => 3);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
      /* Освобождаем курсор */
      PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end DATA_GRID;
  
  /* Диаграмма Ганта */
  procedure GANTT
  is
  begin
    null;
  end GANTT;
  
  /* График */
  procedure CHART
  (
    COUT                    out clob                                           -- Сериализованный график
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY();             -- Организация сеанса
    RCH                     PKG_P8PANELS_VISUAL.TCHART;                        -- График
    RCH_DS                  PKG_P8PANELS_VISUAL.TCHART_DATASET;                -- Набор данных
    RATTR_VALS              PKG_P8PANELS_VISUAL.TCHART_DATASET_ITEM_ATTR_VALS; -- Атрибуты элемента набора данных
  begin
    /* Сформируем заголовок графика */
    RCH := PKG_P8PANELS_VISUAL.TCHART_MAKE(STYPE     => PKG_P8PANELS_VISUAL.SCHART_TYPE_BAR,
                                           STITLE    => 'Топ 5 контрагентов по сумме договоров',
                                           SLGND_POS => PKG_P8PANELS_VISUAL.SCHART_LGND_POS_RIGHT);
    /* Сформируем набор данных */
    RCH_DS := PKG_P8PANELS_VISUAL.TCHART_DATASET_MAKE(SCAPTION => 'Сумма договоров');
    /* Обходим договоры, сгруппированные по контрагентам */
    for C in (select D.SAGENT,
                     D.NSUM
                from (select AG.AGNABBR SAGENT,
                             sum(CN.DOC_SUMTAX * (CN.CURBASE / CN.CURCOURS)) NSUM
                        from CONTRACTS CN,
                             AGNLIST   AG
                       where CN.COMPANY = NCOMPANY
                         and CN.AGENT = AG.RN
                       group by AG.AGNABBR
                       order by 2 desc) D
               where ROWNUM <= 5)
    loop
      /* Добавим метку для контрагента */
      PKG_P8PANELS_VISUAL.TCHART_ADD_LABEL(RCHART => RCH, SLABEL => C.SAGENT);
      /* Сформируем дополнительные атрибуты для клиентского приложения - будем использовать их при открытии раздела "Договоры" для отбора */
      PKG_P8PANELS_VISUAL.TCHART_DATASET_ITM_ATTR_VL_ADD(RATTR_VALS => RATTR_VALS,
                                                         SNAME      => 'SCOND',
                                                         SVALUE     => 'in_SAGENT',
                                                         BCLEAR     => true);
      PKG_P8PANELS_VISUAL.TCHART_DATASET_ITM_ATTR_VL_ADD(RATTR_VALS => RATTR_VALS,
                                                         SNAME      => 'SCOND_VALUE',
                                                         SVALUE     => C.SAGENT);
      /* Добавим контрагента в набор данных */
      PKG_P8PANELS_VISUAL.TCHART_DATASET_ADD_ITEM(RDATASET => RCH_DS, NVALUE => C.NSUM, RATTR_VALS => RATTR_VALS);
    end loop;
    /* Добавим набор данных в график */
    PKG_P8PANELS_VISUAL.TCHART_ADD_DATASET(RCHART => RCH, RDATASET => RCH_DS);
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TCHART_TO_XML(RCHART => RCH, NINCLUDE_DEF => 1);
  end CHART;

end PKG_P8PANELS_SAMPLES;
/
create or replace package PKG_P8PANELS_BASE as

  /*��������� - ������� �������� ���� ��� ������� (��� �������� XML -> JSON) */
  SXML_ALWAYS_ARRAY_POSTFIX  constant PKG_STD.TSTRING := '__SYSTEM__ARRAY__';

  /* ����������� ������ � ����� */
  function UTL_S2N
  (
    SVALUE                  in varchar2 -- �������������� ��������� ��������
  ) return                  number;     -- ���������������� �����

  /* ����������� ���� � ����� */
  function UTL_S2D
  (
    SVALUE                  in varchar2 -- �������������� ��������� ��������
  ) return                  date;       -- ���������������� ����
  
  /* ������� ���������� �������� */
  procedure PROCESS
  (
    CIN                     in clob,    -- ������� ���������
    COUT                    out clob    -- ���������
  );

end PKG_P8PANELS_BASE;
/
create or replace package body PKG_P8PANELS_BASE as

  /* ��������� - ���� ������� �������� */
  SRQ_ACTION_EXEC_STORED    constant PKG_STD.TSTRING := 'EXEC_STORED'; -- ������ �� ���������� �������� ���������

  /* ��������� - ���� �������� */
  SRQ_TAG_XREQUEST          constant PKG_STD.TSTRING := 'XREQUEST';   -- �������� ��� �������
  SRQ_TAG_XPAYLOAD          constant PKG_STD.TSTRING := 'XPAYLOAD';   -- ��� ��� ������ �������
  SRQ_TAG_SACTION           constant PKG_STD.TSTRING := 'SACTION';    -- ��� ��� �������� �������
  SRQ_TAG_SSTORED           constant PKG_STD.TSTRING := 'SSTORED';    -- ��� ��� ����� ��������� ������� � �������
  SRQ_TAG_SRESP_ARG         constant PKG_STD.TSTRING := 'SRESP_ARG';  -- ��� ��� ����� ���������, ������������ ������ ������
  SRQ_TAG_XARGUMENTS        constant PKG_STD.TSTRING := 'XARGUMENTS'; -- ��� ��� ������ ���������� ��������� �������/������� � �������
  SRQ_TAG_XARGUMENT         constant PKG_STD.TSTRING := 'XARGUMENT';  -- ��� ��� ��������� ��������� �������/������� � �������
  SRQ_TAG_SNAME             constant PKG_STD.TSTRING := 'SNAME';      -- ��� ��� ������������ � �������
  SRQ_TAG_SDATA_TYPE        constant PKG_STD.TSTRING := 'SDATA_TYPE'; -- ��� ��� ���� ������ � �������
  SRQ_TAG_VALUE             constant PKG_STD.TSTRING := 'VALUE';      -- ��� ��� �������� � �������

  /* ��������� - ���� ������� */
  SRESP_TAG_XPAYLOAD        constant PKG_STD.TSTRING := 'XPAYLOAD';       -- ��� ��� ������ ������
  SRESP_TAG_XOUT_ARGUMENTS  constant PKG_STD.TSTRING := 'XOUT_ARGUMENTS'; -- ��� ��� �������� ���������� ��������� ������� � ������
  SRESP_TAG_SDATA_TYPE      constant PKG_STD.TSTRING := 'SDATA_TYPE';     -- ��� ��� ���� ������ � ������
  SRESP_TAG_VALUE           constant PKG_STD.TSTRING := 'VALUE';          -- ��� ��� �������� � ������
  SRESP_TAG_SNAME           constant PKG_STD.TSTRING := 'SNAME';          -- ��� ��� ������������ � ������

  /* ��������� - ���� ������ */
  SDATA_TYPE_STR            constant PKG_STD.TSTRING := 'STR';  -- ��� ������ "������"
  SDATA_TYPE_NUMB           constant PKG_STD.TSTRING := 'NUMB'; -- ��� ������ "�����"
  SDATA_TYPE_DATE           constant PKG_STD.TSTRING := 'DATE'; -- ��� ������ "����"
  SDATA_TYPE_CLOB           constant PKG_STD.TSTRING := 'CLOB'; -- ��� ������ "�����"
  
  /* ��������� - ��������� �������� �� */
  SDB_OBJECT_STATE_VALID    constant PKG_STD.TSTRING := 'VALID'; -- ������ �������

  /* ���� ������ - ��������� */
  type TARGUMENT is record
  (
    SNAME                   PKG_STD.TSTRING,  -- ������������
    SDATA_TYPE              PKG_STD.TSTRING,  -- ��� ������ (��. ��������� SPWS_DATA_TYPE_*)
    SVALUE                  PKG_STD.TSTRING,  -- �������� (������)
    NVALUE                  PKG_STD.TLNUMBER, -- �������� (�����)
    DVALUE                  PKG_STD.TLDATE,   -- �������� (����)
    CVALUE                  clob              -- �������� (�����)
  );

  /* ���� ������ - ��������� ���������� ������� */
  type TARGUMENTS is table of TARGUMENT;

  /* ����������� ������ � ����� */
  function UTL_S2N
  (
    SVALUE                  in varchar2      -- �������������� ��������� ��������
  ) return                  number           -- ���������������� �����
  is
    NVALUE                  PKG_STD.TNUMBER; -- ��������� ������
  begin
    /* ������� �������������� */
    NVALUE := TO_NUMBER(replace(SVALUE, ',', '.'));
    /* ����� ��������� */
    return NVALUE;
  exception
    when others then
      P_EXCEPTION(0, '�������� ������ ����� (%s).', SVALUE);
  end UTL_S2N;
  
  /* ����������� ���� � ����� */
  function UTL_S2D
  (
    SVALUE                  in varchar2      -- �������������� ��������� ��������
  ) return                  date             -- ���������������� ����
  is
    DVALUE                  PKG_STD.TLDATE; -- ��������� ������
  begin
    /* ������� �������������� */
    begin
      DVALUE := TO_DATE(SVALUE, 'YYYY-MM-DD');
    exception
      when others then
        begin
          DVALUE := TO_DATE(SVALUE, 'YYYY/MM/DD');
        exception
          when others then
            begin
              DVALUE := TO_DATE(SVALUE, 'DD.MM.YYYY');
            exception
              when others then
                DVALUE := TO_DATE(SVALUE, 'DD/MM/YYYY');
            end;
        end;
    end;
    /* ����� ��������� */
    return DVALUE;
  exception
    when others then
      P_EXCEPTION(0, '�������� ������ ���� (%s).', SVALUE);
  end UTL_S2D;

  /* ������������ ��������� �� ���������� �������� */
  function MSG_NO_DATA_MAKE
  (
    SPATH                   in varchar2 := null, -- ���� �� �������� ��������� ��������
    SMESSAGE_OBJECT         in varchar2 := null  -- ������������� ������� ��� �������������� ��������� �� ������
  ) return                  varchar2             -- �������������� ��������� �� ������
  is
    SPATH_                  PKG_STD.TSTRING;     -- ����� ��� ����
    SMESSAGE_OBJECT_        PKG_STD.TSTRING;     -- ����� ��� ������������ �������
  begin
    /* ���������� ���� � ������ */
    if (SPATH is not null) then
      SPATH_ := ' (' || SPATH || ')';
    end if;
    /* ���������� ������������ ������� � ������ */
    if (SMESSAGE_OBJECT is not null) then
      SMESSAGE_OBJECT_ := ' �������� "' || SMESSAGE_OBJECT || '"';
    else
      SMESSAGE_OBJECT_ := ' ��������';
    end if;
    /* ����� �������������� ��������� */
    return '�� ������� ��������' || SMESSAGE_OBJECT_ || SPATH_ || '.';
  end MSG_NO_DATA_MAKE;

  /* ����������� ������������ ���� ������ (PKG_STD) � ��� ������ ������� (PWS) */
  function STD_DATA_TYPE_TO_STR
  (
    NSTD_DATA_TYPE          in number        -- ���������� ��� ������
  ) return                  varchar2         -- ��������������� ��� ������ �������
  is
    SRES                    PKG_STD.TSTRING; -- ����� ��� ����������
  begin
    /* �������� �� ���� ������ */
    case NSTD_DATA_TYPE
      /* ������ */
      when PKG_STD.DATA_TYPE_STR then
        SRES := SDATA_TYPE_STR;
      /* ����� */
      when PKG_STD.DATA_TYPE_NUM then
        SRES := SDATA_TYPE_NUMB;
      /* ���� */
      when PKG_STD.DATA_TYPE_DATE then
        SRES := SDATA_TYPE_DATE;
      /* ����� */
      when PKG_STD.DATA_TYPE_CLOB then
        SRES := SDATA_TYPE_CLOB;
      /* ����������� ��� ������ */
      else
        P_EXCEPTION(0, '��� ������ "%s" �� ��������������.', TO_CHAR(NSTD_DATA_TYPE));
    end case;
    /* ���������� ��������� */
    return SRES;
  end STD_DATA_TYPE_TO_STR;

  /* ���������� �������� ����� XML (������) */
  function NODE_SVAL_GET
  (
    XROOT                   in PKG_XPATH.TNODE, -- �������� ����� ��� ���������� ��������
    SPATH                   in varchar2,        -- ���� ��� ���������� ������
    NREQUIRED               in number := 0,     -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
    SMESSAGE_OBJECT         in varchar2 := null -- ������������� ������� ��� �������������� ��������� �� ������
  ) return                  varchar2            -- ��������� ��������
  is
    XNODE                   PKG_XPATH.TNODE;    -- ������� ����� �� ��������� (���������� ��� ������)
    SVAL                    PKG_STD.TSTRING;    -- ��������� ������
  begin
    /* ������ ������ ����� �� ������� */
    XNODE := PKG_XPATH.SINGLE_NODE(RPARENT_NODE => XROOT, SPATTERN => SPATH);
    /* ���� ��� ��� ������ */
    if (PKG_XPATH.IS_NULL(RNODE => XNODE)) then
      /* ��� � ����� */
      SVAL := null;
    else
      /* ���-�� ���� - ������ ������ */
      begin
        SVAL := PKG_XPATH.VALUE(RNODE => XNODE);
      exception
        when others then
          P_EXCEPTION(0, '�������� ������ ������ (%s).', SPATH);
      end;
    end if;
    /* ���� �������� ���, � ��� ������ ���� - ������ �� ���� */
    if ((SVAL is null) and (NREQUIRED = 1)) then
      P_EXCEPTION(0, MSG_NO_DATA_MAKE(SPATH => SPATH, SMESSAGE_OBJECT => SMESSAGE_OBJECT));
    end if;
    /* ����� ��������� */
    return SVAL;
  end NODE_SVAL_GET;

  /* ���������� �������� ����� XML (�����) */
  function NODE_NVAL_GET
  (
    XROOT                   in PKG_XPATH.TNODE, -- �������� ����� ��� ���������� ��������
    SPATH                   in varchar2,        -- ���� ��� ���������� ������
    NREQUIRED               in number := 0,     -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
    SMESSAGE_OBJECT         in varchar2 := null -- ������������� ������� ��� �������������� ��������� �� ������
  ) return                  number              -- ��������� ��������
  is
    XNODE                   PKG_XPATH.TNODE;    -- ������� ����� �� ��������� (���������� ��� ������)
    NVAL                    PKG_STD.TLNUMBER;   -- ��������� ������
  begin
    /* ������ ������ ����� �� ������� */
    XNODE := PKG_XPATH.SINGLE_NODE(RPARENT_NODE => XROOT, SPATTERN => SPATH);
    /* ���� ��� ��� ������ */
    if (PKG_XPATH.IS_NULL(RNODE => XNODE)) then
      /* ��� � ����� */
      NVAL := null;
    else
      /* ���-�� ���� - ������ ������ */
      begin
        NVAL := PKG_XPATH.VALUE_NUM(RNODE => XNODE);
      exception
        when others then
          P_EXCEPTION(0, '�������� ������ ����� (%s).', SPATH);
      end;
    end if;
    /* ���� �������� ���, � ��� ������ ���� - ������ �� ���� */
    if ((NVAL is null) and (NREQUIRED = 1)) then
      P_EXCEPTION(0, MSG_NO_DATA_MAKE(SPATH => SPATH, SMESSAGE_OBJECT => SMESSAGE_OBJECT));
    end if;
    /* ����� ��������� */
    return NVAL;
  end NODE_NVAL_GET;

  /* ���������� �������� ����� XML (����) */
  function NODE_DVAL_GET
  (
    XROOT                   in PKG_XPATH.TNODE, -- �������� ����� ��� ���������� ��������
    SPATH                   in varchar2,        -- ���� ��� ���������� ������
    NREQUIRED               in number := 0,     -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
    SMESSAGE_OBJECT         in varchar2 := null -- ������������� ������� ��� �������������� ��������� �� ������
  ) return                  date                -- ��������� ��������
  is
    XNODE                   PKG_XPATH.TNODE;    -- ������� ����� �� ��������� (���������� ��� ������)
    DVAL                    PKG_STD.TLDATE;     -- ��������� ������
  begin
    /* ������ ������ ����� �� ������� */
    XNODE := PKG_XPATH.SINGLE_NODE(RPARENT_NODE => XROOT, SPATTERN => SPATH);
    /* ���� ��� ��� ������ */
    if (PKG_XPATH.IS_NULL(RNODE => XNODE)) then
      /* ��� � ����� */
      DVAL := null;
    else
      /* ���-�� ���� - ������ ������ */
      begin
        DVAL := PKG_XPATH.VALUE_DATE(RNODE => XNODE);
      exception
        when others then
          begin
            DVAL := PKG_XPATH.VALUE_TS(RNODE => XNODE);
          exception
            when others then
              begin
                DVAL := PKG_XPATH.VALUE_TZ(RNODE => XNODE);
              exception
                when others then
                  P_EXCEPTION(0,
                              '�������� ������ ���� (%s). ���������: YYYY-MM-DD"T"HH24:MI:SS.FF3tzh:tzm, YYYY-MM-DD"T"HH24:MI:SS.FF3, YYYY-MM-DD"T"HH24:MI:SS, YYYY-MM-DD.',
                              SPATH);
              end;
          end;
      end;
    end if;
    /* ���� �������� ���, � ��� ������ ���� - ������ �� ���� */
    if ((DVAL is null) and (NREQUIRED = 1)) then
      P_EXCEPTION(0, MSG_NO_DATA_MAKE(SPATH => SPATH, SMESSAGE_OBJECT => SMESSAGE_OBJECT));
    end if;
    /* ����� ��������� */
    return DVAL;
  end NODE_DVAL_GET;
  
  /* ���������� �������� ����� XML (�����) */
  function NODE_CVAL_GET
  (
    XROOT                   in PKG_XPATH.TNODE, -- �������� ����� ��� ���������� ��������
    SPATH                   in varchar2,        -- ���� ��� ���������� ������
    NREQUIRED               in number := 0,     -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
    SMESSAGE_OBJECT         in varchar2 := null -- ������������� ������� ��� �������������� ��������� �� ������
  ) return                  clob                -- ��������� ��������
  is
    XNODE                   PKG_XPATH.TNODE;    -- ������� ����� �� ��������� (���������� ��� ������)
    CVAL                    clob;               -- ��������� ������
  begin
    /* ������ ������ ����� �� ������� */
    XNODE := PKG_XPATH.SINGLE_NODE(RPARENT_NODE => XROOT, SPATTERN => SPATH);
    /* ���� ��� ��� ������ */
    if (PKG_XPATH.IS_NULL(RNODE => XNODE)) then
      /* ��� � ����� */
      CVAL := null;
    else
      /* ���-�� ���� - ������ ������ */
      begin
        CVAL := PKG_XPATH.VALUE_CLOB(RNODE => XNODE);
      exception
        when others then
          P_EXCEPTION(0, '�������� ������ ��������� ������ (%s).', SPATH);
      end;
    end if;
    /* ���� �������� ���, � ��� ������ ���� - ������ �� ���� */
    if ((CVAL is null) and (NREQUIRED = 1)) then
      P_EXCEPTION(0, MSG_NO_DATA_MAKE(SPATH => SPATH, SMESSAGE_OBJECT => SMESSAGE_OBJECT));
    end if;
    /* ����� ��������� */
    return CVAL;
  end NODE_CVAL_GET;
  
  /* ���������� ��������� �� ��������� */
  function TARGUMENTS_GET
  (
    ARGUMENTS               in TARGUMENTS, -- ��������� ����������
    SARGUMENT               in varchar2,   -- ��� ���������
    NREQUIRED               in number := 0 -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  TARGUMENT      -- ��������� ��������
  is
  begin
    /* ���� ������ � ��������� ���� */
    if ((ARGUMENTS is not null) and (ARGUMENTS.COUNT > 0)) then
      /* ������� � */
      for I in ARGUMENTS.FIRST .. ARGUMENTS.LAST
      loop
        /* ���� ���������� ������ �������� */
        if (ARGUMENTS(I).SNAME = SARGUMENT) then
          /* ����� ��� */
          return ARGUMENTS(I);
        end if;
      end loop;
    end if;
    /* ���� �� ����� - �������� �� �������, ����� �������� ��������� �� ������ ���� �� ��� ������������ */
    if (NREQUIRED = 1) then
      P_EXCEPTION(0, '�� ����� ������������ �������� "%s".', SARGUMENT);
    else
      /* �� �� ������������ - ����� ���������� ������ */
      return null;
    end if;
  end TARGUMENTS_GET;

  /* ���������� �������� ��������� �� ��������� (������) */
  function TARGUMENTS_SVAL_GET
  (
    ARGUMENTS               in TARGUMENTS, -- ��������� ����������
    SARGUMENT               in varchar2,   -- ��� ���������
    NREQUIRED               in number := 0 -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  varchar2       -- �������� ���������
  is
  begin
    /* ������� � ����� �������� */
    return TARGUMENTS_GET(ARGUMENTS => ARGUMENTS, SARGUMENT => SARGUMENT, NREQUIRED => NREQUIRED).SVALUE;
  end TARGUMENTS_SVAL_GET;

  /* ���������� �������� ��������� �� ������� (�����) */
  function TARGUMENTS_NVAL_GET
  (
    ARGUMENTS               in TARGUMENTS, -- ��������� ����������
    SARGUMENT               in varchar2,   -- ��� ���������
    NREQUIRED               in number := 0 -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  number         -- �������� ���������
  is
  begin
    /* ������� � ����� �������� */
    return TARGUMENTS_GET(ARGUMENTS => ARGUMENTS, SARGUMENT => SARGUMENT, NREQUIRED => NREQUIRED).NVALUE;
  end TARGUMENTS_NVAL_GET;

  /* ���������� �������� ��������� �� ������� (����) */
  function TARGUMENTS_DVAL_GET
  (
    ARGUMENTS               in TARGUMENTS, -- ��������� ����������
    SARGUMENT               in varchar2,   -- ��� ���������
    NREQUIRED               in number := 0 -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  date           -- �������� ���������
  is
  begin
    /* ������� � ����� �������� */
    return TARGUMENTS_GET(ARGUMENTS => ARGUMENTS, SARGUMENT => SARGUMENT, NREQUIRED => NREQUIRED).DVALUE;
  end TARGUMENTS_DVAL_GET;

  /* ���������� �������� ��������� �� ������� (�����) */
  function TARGUMENTS_CVAL_GET
  (
    ARGUMENTS               in TARGUMENTS, -- ��������� ����������
    SARGUMENT               in varchar2,   -- ��� ���������
    NREQUIRED               in number := 0 -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  clob           -- �������� ���������
  is
  begin
    /* ������� � ����� �������� */
    return TARGUMENTS_GET(ARGUMENTS => ARGUMENTS, SARGUMENT => SARGUMENT, NREQUIRED => NREQUIRED).CVALUE;
  end TARGUMENTS_CVAL_GET;

  /* ��������� ��������� �������� ���� ������� */
  function RQ_ROOT_GET
  (
    CRQ                     in clob         -- ������
  ) return                  PKG_XPATH.TNODE -- �������� ������� ������ ����� ���� ���������
  is
  begin
    /* ���������� �������� ������� ��������� */
    return PKG_XPATH.ROOT_NODE(RDOCUMENT => PKG_XPATH.PARSE_FROM_CLOB(LCXML => CRQ));
  end RQ_ROOT_GET;

  /* ��������� ���� � ������� */
  function RQ_PATH_GET
  return                    varchar2    -- ���� � �������
  is
  begin
    return '/' || SRQ_TAG_XREQUEST;
  end RQ_PATH_GET;

  /* ��������� ���� � �������� �������� ������� */
  function RQ_ACTION_PATH_GET
  return                    varchar2    -- ���� � �������� �������� �������
  is
  begin
    return RQ_PATH_GET() || '/' || SRQ_TAG_SACTION;
  end RQ_ACTION_PATH_GET;
  
  /* ��������� ���� �������� ������� */
  function RQ_ACTION_GET
  (
    XRQ_ROOT                in PKG_XPATH.TNODE := null, -- �������� ����� �������
    NREQUIRED               in number := 0              -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  varchar2                    -- ��� �������� �������
  is
  begin
    /* ������ �������� �������� ���� � ����� �������� */
    return NODE_SVAL_GET(XROOT           => XRQ_ROOT,
                         SPATH           => RQ_ACTION_PATH_GET(),
                         NREQUIRED       => NREQUIRED,
                         SMESSAGE_OBJECT => '��� ��������');
  end RQ_ACTION_GET;

  /* ��������� ���� � ���������� ������� */
  function RQ_PAYLOAD_PATH_GET
  return                    varchar2    -- ���� � ���������� �������
  is
  begin
    /* ������ �������� */
    return RQ_PATH_GET() || '/' || SRQ_TAG_XPAYLOAD;
  end RQ_PAYLOAD_PATH_GET;

  /* ��������� ���� � �������� ���������� ������� */
  function RQ_PAYLOAD_ITEM_PATH_GET
  (
    SITEM_TAG               in varchar2 -- ��� ��������
  )
  return                    varchar2    -- ���� � �������� ���������� �������
  is
  begin
    /* ������ �������� */
    return RQ_PAYLOAD_PATH_GET() || '/' || SITEM_TAG;
  end RQ_PAYLOAD_ITEM_PATH_GET;

  /* ���������� ������������ ������������ ��������� ������� �� ������� */
  function RQ_PAYLOAD_STORED_GET
  (
    XRQ_ROOT                in PKG_XPATH.TNODE := null, -- �������� ����� �������
    NREQUIRED               in number := 0              -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  varchar2                    -- ������������ ������������ ��������� ������� �� �������
  is
  begin
    /* ������ �������� �������� ���� � ������������� ��������� ������� */
    return NODE_SVAL_GET(XROOT           => XRQ_ROOT,
                         SPATH           => RQ_PAYLOAD_ITEM_PATH_GET(SITEM_TAG => SRQ_TAG_SSTORED),
                         NREQUIRED       => NREQUIRED,
                         SMESSAGE_OBJECT => '������������ ���������/�������');
  end RQ_PAYLOAD_STORED_GET;
  
  /* �������� ������������ ��������� ������� �� ������� */
  procedure RQ_PAYLOAD_STORED_CHECK
  (
    XRQ_ROOT                in PKG_XPATH.TNODE,       -- �������� ����� �������
    SSTORED                 in varchar2 := null       -- ������������ ������������ ��������� ������� (null - �������������� ���������� �� �������)
  )
  is
    SSTORED_                PKG_STD.TSTRING;          -- ����� ��� ������������ ������������ ��������� �������
    RSTORED                 PKG_OBJECT_DESC.TSTORED;  -- �������� ��������� ������� �� ��
    SPROCEDURE              PKG_STD.TSTRING;          -- ����� ��� ������������ �������� ���������
    SPACKAGE                PKG_STD.TSTRING;          -- ����� ��� ������������ ������, ����������� �������� ������
    RPACKAGE                PKG_OBJECT_DESC.TPACKAGE; -- �������� ������, ����������� �������� ������
  begin
    /* ������� ������������ ������� �� ������� ��� ���������� ���������� � ���������� */
    if (SSTORED is not null) then
      SSTORED_ := SSTORED;
    else
      SSTORED_ := RQ_PAYLOAD_STORED_GET(XRQ_ROOT => XRQ_ROOT, NREQUIRED => 1);
    end if;
    /* ��������, ��� ��� ��������� ��� ������� � ��� ������ ���������� */
    if (PKG_OBJECT_DESC.EXISTS_STORED(SSTORED_NAME => SSTORED_) = 0) then
      P_EXCEPTION(0,
                  '�������� ���������/������� "' || SSTORED_ || '" �� ����������.');
    else
      /* ��������, ��� � ����� ��� ������ �� ����� */
      PKG_EXS.UTL_STORED_PARSE_LINK(SSTORED => SSTORED_, SPROCEDURE => SPROCEDURE, SPACKAGE => SPACKAGE);
      /* ���� � ����� ���� ������ �� ����� - ������� �������� ��� ��������� */
      if (SPACKAGE is not null) then
        RPACKAGE := PKG_OBJECT_DESC.DESC_PACKAGE(SPACKAGE_NAME => SPACKAGE, BRAISE_ERROR => false);
      end if;
      /* ���� ���� ������ �� �����, ��� �� �� ������� - ��� ������ */
      if ((SPACKAGE is not null) and (RPACKAGE.STATUS <> SDB_OBJECT_STATE_VALID)) then
        P_EXCEPTION(0,
                    '����� "' || SPACKAGE ||
                    '", ���������� �������� ���������/�������, ���������. ��������� � ������� ����������.');
      else
        /* ��� ������ �� ����� ��� �� ������� - ��������� ������, ������� �������� ������� �� �� */
        RSTORED := PKG_OBJECT_DESC.DESC_STORED(SSTORED_NAME => SSTORED_, BRAISE_ERROR => false);
        /* ��������, ��� ������� */
        if (RSTORED.STATUS <> SDB_OBJECT_STATE_VALID) then
          P_EXCEPTION(0,
                      '�������� ���������/������� "' || SSTORED_ || '" ���������. ��������� � ������� ����������.');
        else
          /* ��������, ��� ��� ���������� ������ */
          if (PKG_OBJECT_DESC.EXISTS_PRIV_EXECUTE(SSTORED_NAME => COALESCE(RSTORED.PACKAGE_NAME, SSTORED_)) = 0) then
            P_EXCEPTION(0,
                        '�������� ���������/������� "' || SSTORED_ ||
                        '" �� �������� ����������. ��������� � ������� ����������.');
          end if;
        end if;
      end if;
    end if;
  end RQ_PAYLOAD_STORED_CHECK;

  /* ���������� ������ ���������� �� ������� */
  function RQ_PAYLOAD_ARGUMENTS_GET
  (
    XRQ_ROOT                in PKG_XPATH.TNODE, -- �������� ����� �������
    NREQUIRED               in number := 0      -- ���� ������ ��������� �� ������ � ������ ���������� �������� (0 - �� ��������, 1 - ��������)
  ) return                  TARGUMENTS          -- ��������� ���������� �� �������
  is
    RES                     TARGUMENTS;         -- ��������� ������
    SRQ_ARGUMENTS_PATH      PKG_STD.TSTRING;    -- ������ ���� �� ���������� ������� � �������
    XRQ_ARGUMENTS           PKG_XPATH.TNODES;   -- ��������� ��������� ��������� ������� � �����������
    XRQ_ARGUMENT            PKG_XPATH.TNODE;    -- ������� ��������� ������� � ����������
  begin
    /* �������������� ��������� */
    RES := TARGUMENTS();
    /* ���������� ������ ���� �� ���������� � ������� */
    SRQ_ARGUMENTS_PATH := RQ_PAYLOAD_ITEM_PATH_GET(SITEM_TAG => SRQ_TAG_XARGUMENTS) || '/' || SRQ_TAG_XARGUMENT;
    /* ������� ��������� ���������� �� ��������� */
    XRQ_ARGUMENTS := PKG_XPATH.LIST_NODES(RPARENT_NODE => XRQ_ROOT, SPATTERN => SRQ_ARGUMENTS_PATH);
    /* ������� ��������� ���������� �� ��������� */
    for I in 1 .. PKG_XPATH.COUNT_NODES(RNODES => XRQ_ARGUMENTS)
    loop
      /* ����� ��������� �������� */
      XRQ_ARGUMENT := PKG_XPATH.ITEM_NODE(RNODES => XRQ_ARGUMENTS, INUMBER => I);
      /* ��������� ��� � �������� ��������� */
      RES.EXTEND();
      RES(RES.LAST).SNAME := NODE_SVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_SNAME);
      RES(RES.LAST).SDATA_TYPE := NODE_SVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_SDATA_TYPE);
      /* �������� ������������ ������ - ������������ */
      if (RES(RES.LAST).SNAME is null) then
        P_EXCEPTION(0,
                    '��� ��������� �� ������ ������������ (%s).',
                    SRQ_ARGUMENTS_PATH || '/' || SRQ_TAG_SNAME);
      end if;
      /* �������� ������������ ������ - ��� ������ */
      if (RES(RES.LAST).SDATA_TYPE is null) then
        P_EXCEPTION(0,
                    '��� ��������� "%s" �� ����� ��� ������ (%s).',
                    RES(RES.LAST).SNAME,
                    SRQ_ARGUMENTS_PATH || '/' || SRQ_TAG_SDATA_TYPE);
      end if;
      /* ������� �������� � ����������� �� ���� ������ */
      case
        /* ������ */
        when (RES(RES.LAST).SDATA_TYPE = SDATA_TYPE_STR) then
          RES(RES.LAST).SVALUE := NODE_SVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_VALUE);
        /* ����� */
        when (RES(RES.LAST).SDATA_TYPE = SDATA_TYPE_NUMB) then
          RES(RES.LAST).NVALUE := NODE_NVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_VALUE);
        /* ���� */
        when (RES(RES.LAST).SDATA_TYPE = SDATA_TYPE_DATE) then
          RES(RES.LAST).DVALUE := NODE_DVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_VALUE);
        /* ����� */
        when (RES(RES.LAST).SDATA_TYPE = SDATA_TYPE_CLOB) then
          RES(RES.LAST).CVALUE := NODE_CVAL_GET(XROOT => XRQ_ARGUMENT, SPATH => SRQ_TAG_VALUE);
        /* ���������������� ��� ������ */
        else
          P_EXCEPTION(0,
                      '��������� ��� ��������� "%s" ��� ������ "%s" �� �������������� (%s).',
                      RES(RES.LAST).SNAME,
                      RES(RES.LAST).SDATA_TYPE,
                      SRQ_ARGUMENTS_PATH || '/' || SRQ_TAG_SDATA_TYPE);
      end case;
    end loop;
    /* �������� �������������� */
    if ((RES.COUNT = 0) and (NREQUIRED = 1)) then
      P_EXCEPTION(0, '�� ������� ��������� (' || SRQ_ARGUMENTS_PATH || ').');
    end if;
    /* ���������� ��������� */
    return RES;
  end RQ_PAYLOAD_ARGUMENTS_GET;

  /* ���������� �������� ��������� */
  procedure EXEC_STORED
  (
    XRQ_ROOT                in PKG_XPATH.TNODE,         -- �������� ������� ���� ��������� �������
    COUT                    out clob                    -- ����� �� ������
  )
  is
    SRQ_STORED              PKG_STD.TSTRING;            -- ������������ ������������ ��������� ������� �� �������
    SRQ_RESP_ARG            PKG_STD.TSTRING;            -- ������������ ��������� ��������� ��������� ������� �� ������� ��� ������������ ���� ������
    RQ_ARGUMENTS            TARGUMENTS;                 -- ��������� ���������� ��������� ������� �� �������
    ARGS                    PKG_OBJECT_DESC.TARGUMENTS; -- ��������� ���������� ���������� ��������� �������
    RARG                    PKG_OBJECT_DESC.TARGUMENT;  -- ���������� �������� ��������� �������
    ARGS_VALS               PKG_CONTPRMLOC.TCONTAINER;  -- ��������� ��� ����������� ���������� ��������� �������
    RARG_VAL                PKG_CONTAINER.TPARAM;       -- ����������� �������� ��������� �������
    SARG_NAME               PKG_STD.TSTRING;            -- ������������ �������� ��������������� ������������ ��������� ��������� �������
    XRESP                   integer;                    -- �������� ��� ������
    XRESP_OUT_ARGUMENTS     PKG_XMAKE.TNODE;            -- ������� ��� ��������� �������� ���������� ��������� �������
    RRESP_ARGUMENT_VALUE    PKG_XMAKE.TVALUE;           -- �������� ��������� ��������� ��������� �������
    BRESP_ARG_FOUND         boolean := false;           -- ���� ����������� � ������� �������� ���������� ��������� � ����� CLOB � ������, ��������� � ��������� ������� SRESP_ARG
  begin
    /* ������ �������� ��� ������ */
    XRESP := PKG_XMAKE.OPEN_CURSOR();
    /* �������� �������� ������ � ������� */
    RQ_PAYLOAD_STORED_CHECK(XRQ_ROOT => XRQ_ROOT);
    /* ��������� ������������ ��������� ������� �� ������� */
    SRQ_STORED := RQ_PAYLOAD_STORED_GET(XRQ_ROOT => XRQ_ROOT, NREQUIRED => 1);
    /* ��������� ������������ ��������� ��������� ��������� ������� �� ������� ��� ������������ ���� ������ */
    SRQ_RESP_ARG := NODE_SVAL_GET(XROOT           => XRQ_ROOT,
                                  SPATH           => RQ_PAYLOAD_ITEM_PATH_GET(SITEM_TAG => SRQ_TAG_SRESP_ARG),
                                  NREQUIRED       => 0,
                                  SMESSAGE_OBJECT => '������������ ��������� ��������� ��� ������������ ���� ������');
    /* ������� ������ ���������� �� ������� */
    RQ_ARGUMENTS := RQ_PAYLOAD_ARGUMENTS_GET(XRQ_ROOT => XRQ_ROOT);
    /* ��������� �������� ���������� ��������� ������� */
    ARGS := PKG_OBJECT_DESC.DESC_ARGUMENTS(SSTORED_NAME => SRQ_STORED, BRAISE_ERROR => true);
    /* ������� ������� ��������� � ��������� ��������� �������� */
    for I in 1 .. PKG_OBJECT_DESC.COUNT_ARGUMENTS(RARGUMENTS => ARGS)
    loop
      /* ��������� ��������� �������� */
      RARG := PKG_OBJECT_DESC.FETCH_ARGUMENT(RARGUMENTS => ARGS, IINDEX => I);
      /* ���� ��� ������� �������� */
      if (RARG.IN_OUT in (PKG_STD.PARAM_TYPE_IN, PKG_STD.PARAM_TYPE_IN_OUT)) then
        /* ������� ��� �������� � ��������� ����������� ���������� */
        case RARG.DATA_TYPE
          /* ������ */
          when PKG_STD.DATA_TYPE_STR then
            PKG_CONTPRMLOC.APPENDS(RCONTAINER => ARGS_VALS,
                                   SNAME      => RARG.ARGUMENT_NAME,
                                   SVALUE     => TARGUMENTS_SVAL_GET(ARGUMENTS => RQ_ARGUMENTS,
                                                                     SARGUMENT => RARG.ARGUMENT_NAME),
                                   NIN_OUT    => RARG.IN_OUT);
          /* ����� */
          when PKG_STD.DATA_TYPE_NUM then
            PKG_CONTPRMLOC.APPENDN(RCONTAINER => ARGS_VALS,
                                   SNAME      => RARG.ARGUMENT_NAME,
                                   NVALUE     => TARGUMENTS_NVAL_GET(ARGUMENTS => RQ_ARGUMENTS,
                                                                     SARGUMENT => RARG.ARGUMENT_NAME),
                                   NIN_OUT    => RARG.IN_OUT);
          /* ���� */
          when PKG_STD.DATA_TYPE_DATE then
            PKG_CONTPRMLOC.APPENDD(RCONTAINER => ARGS_VALS,
                                   SNAME      => RARG.ARGUMENT_NAME,
                                   DVALUE     => TARGUMENTS_DVAL_GET(ARGUMENTS => RQ_ARGUMENTS,
                                                                     SARGUMENT => RARG.ARGUMENT_NAME),
                                   NIN_OUT    => RARG.IN_OUT);
          /* ����� */
          when PKG_STD.DATA_TYPE_CLOB then
            PKG_CONTPRMLOC.APPENDLC(RCONTAINER => ARGS_VALS,
                                    SNAME      => RARG.ARGUMENT_NAME,
                                    LCVALUE    => TARGUMENTS_CVAL_GET(ARGUMENTS => RQ_ARGUMENTS,
                                                                      SARGUMENT => RARG.ARGUMENT_NAME),
                                    NIN_OUT    => RARG.IN_OUT);
          /* ����������� ��� ������ */
          else
            P_EXCEPTION(0,
                        '��� ������ (%s) �������� ��������� "%s" �� ��������������.',
                        RARG.DB_DATA_TYPE,
                        RARG.ARGUMENT_NAME);
        end case;
      end if;
    end loop;
    /* ��������� ��������� */
    PKG_SQL_CALL.EXECUTE_STORED(SSTORED_NAME => SRQ_STORED, RPARAM_CONTAINER => ARGS_VALS);
    /* ������� �������� ��������� � �������� �� � ����� */
    SARG_NAME := PKG_CONTPRMLOC.FIRST_(RCONTAINER => ARGS_VALS);
    while (SARG_NAME is not null)
    loop
      /* ��������� ��������� �������� */
      RARG_VAL := PKG_CONTPRMLOC.GET(RCONTAINER => ARGS_VALS, SNAME => SARG_NAME);
      /* ���� ��� �������� �������� */
      if (RARG_VAL.IN_OUT in (PKG_STD.PARAM_TYPE_IN_OUT, PKG_STD.PARAM_TYPE_OUT)) then
        /* ���������� ��� ���� �������� � ����������� �� ��� ���� */
        case RARG_VAL.DATA_TYPE
          /* ������ */
          when PKG_STD.DATA_TYPE_STR then
            RRESP_ARGUMENT_VALUE := PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                    SVALUE  => PKG_CONTPRMLOC.GETS(RCONTAINER => ARGS_VALS,
                                                                                   SNAME      => RARG_VAL.NAME));
          /* ����� */
          when PKG_STD.DATA_TYPE_NUM then
            RRESP_ARGUMENT_VALUE := PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                    NVALUE  => PKG_CONTPRMLOC.GETN(RCONTAINER => ARGS_VALS,
                                                                                   SNAME      => RARG_VAL.NAME));
          /* ���� */
          when PKG_STD.DATA_TYPE_DATE then
            RRESP_ARGUMENT_VALUE := PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                    DVALUE  => PKG_CONTPRMLOC.GETD(RCONTAINER => ARGS_VALS,
                                                                                   SNAME      => RARG_VAL.NAME));
          /* ����� */
          when PKG_STD.DATA_TYPE_CLOB then
            RRESP_ARGUMENT_VALUE := PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                    LCVALUE => PKG_CONTPRMLOC.GETLC(RCONTAINER => ARGS_VALS,
                                                                                    SNAME      => RARG_VAL.NAME));
            if ((SRQ_RESP_ARG is not null) and (RARG_VAL.NAME = SRQ_RESP_ARG)) then
              COUT            := PKG_CONTPRMLOC.GETLC(RCONTAINER => ARGS_VALS, SNAME => RARG_VAL.NAME);
              BRESP_ARG_FOUND := true;
              exit;
            end if;
          /* ����������� ��� ������ */
          else
            P_EXCEPTION(0,
                        '��� ������ (%s) ��������� ��������� "%s" �� ��������������.',
                        RARG.DB_DATA_TYPE,
                        RARG.ARGUMENT_NAME);
        end case;
        /* ������� ����� ��������� ��������� � �������� ��������� */
        XRESP_OUT_ARGUMENTS := PKG_XMAKE.CONCAT(ICURSOR => XRESP,
                                                RNODE00 => XRESP_OUT_ARGUMENTS,
                                                RNODE01 => PKG_XMAKE.ELEMENT(ICURSOR => XRESP,
                                                                             SNAME   => SRESP_TAG_XOUT_ARGUMENTS,
                                                                             RNODE00 => PKG_XMAKE.ELEMENT(ICURSOR  => XRESP,
                                                                                                          SNAME    => SRESP_TAG_SNAME,
                                                                                                          RVALUE00 => PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                                                                                                      SVALUE  => RARG_VAL.NAME)),
                                                                             RNODE01 => PKG_XMAKE.ELEMENT(ICURSOR  => XRESP,
                                                                                                          SNAME    => SRESP_TAG_VALUE,
                                                                                                          RVALUE00 => RRESP_ARGUMENT_VALUE),
                                                                             RNODE02 => PKG_XMAKE.ELEMENT(ICURSOR  => XRESP,
                                                                                                          SNAME    => SRESP_TAG_SDATA_TYPE,
                                                                                                          RVALUE00 => PKG_XMAKE.VALUE(ICURSOR => XRESP,
                                                                                                                                      SVALUE  => STD_DATA_TYPE_TO_STR(NSTD_DATA_TYPE => RARG_VAL.DATA_TYPE)))));
      end if;
      /* ��������� ������������ ���������� ��������� */
      SARG_NAME := PKG_CONTPRMLOC.NEXT_(RCONTAINER => ARGS_VALS, SNAME => SARG_NAME);
    end loop;
    /* ��������, ��� ��� ������ ������������ �������� ��� ������������ ������� ������ */
    if ((SRQ_RESP_ARG is not null) and (not BRESP_ARG_FOUND)) then
      P_EXCEPTION(0,
                  '� ������� �������� ���������� "%s" ���������� �������� "%s" ���� "CLOB".',
                  SRQ_STORED,
                  SRQ_RESP_ARG);
    end if;
    /* �������� ����� (������ ���� �� ����������� ������ ����� ����� �������� ��� ������������ ������� ������) */
    if (not BRESP_ARG_FOUND) then
      COUT := PKG_XMAKE.SERIALIZE_TO_CLOB(ICURSOR => XRESP,
                                          ITYPE   => PKG_XMAKE.CONTENT_,
                                          RNODE   => PKG_XMAKE.ELEMENT(ICURSOR => XRESP,
                                                                       SNAME   => SRESP_TAG_XPAYLOAD,
                                                                       RNODE00 => XRESP_OUT_ARGUMENTS));
    end if;
    /* ������� ��������� ���������� */
    PKG_CONTPRMLOC.PURGE(RCONTAINER => ARGS_VALS);
    /* ����������� �������� ���������� */
    PKG_XMAKE.CLOSE_CURSOR(ICURSOR => XRESP);
  exception
    when others then
      /* ������� ������ � ������ ������ */
      PKG_XMAKE.CLOSE_CURSOR(ICURSOR => XRESP);
      /* ������� ������ */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end EXEC_STORED;
  
  /* ������� ���������� �������� */
  procedure PROCESS
  (
    CIN                     in clob,         -- ������� ���������
    COUT                    out clob         -- ���������
  )
  is
    XRQ_ROOT                PKG_XPATH.TNODE; -- �������� ������� ���� ��������� �������
    SRQ_ACTION              PKG_STD.TSTRING; -- ��� �������� �� �������
  begin
    PKG_TRACE.REGISTER(SDATA => 'P8PANELS', SDATA1 => CIN);
    /* ��������� ������ */
    XRQ_ROOT := RQ_ROOT_GET(CRQ => CIN);
    /* ��������� ��� �������� �� ������� */
    SRQ_ACTION := RQ_ACTION_GET(XRQ_ROOT => XRQ_ROOT, NREQUIRED => 1);
    /* �������� ���������� � ����������� �� ���� �������� */
    case SRQ_ACTION
    /* ���������� �������� ��������� */
      when SRQ_ACTION_EXEC_STORED then
        EXEC_STORED(XRQ_ROOT => XRQ_ROOT, COUT => COUT);
        /* ����������� �������� */
      else
        P_EXCEPTION(0, '�������� "%s" �� ��������������.', SRQ_ACTION);
    end case;
  end PROCESS;

end PKG_P8PANELS_BASE;
/

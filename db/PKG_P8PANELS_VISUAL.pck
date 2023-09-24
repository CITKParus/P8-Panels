create or replace package PKG_P8PANELS_VISUAL as

  /* ��������� - ���� ������ */
  SDATA_TYPE_STR            constant PKG_STD.TSTRING := 'STR';  -- ��� ������ "������"
  SDATA_TYPE_NUMB           constant PKG_STD.TSTRING := 'NUMB'; -- ��� ������ "�����"
  SDATA_TYPE_DATE           constant PKG_STD.TSTRING := 'DATE'; -- ��� ������ "����"
  
  /* ��������� - ����������� ���������� */
  SORDER_DIRECTION_ASC      constant PKG_STD.TSTRING := 'ASC';  -- �� �����������
  SORDER_DIRECTION_DESC     constant PKG_STD.TSTRING := 'DESC'; -- �� ��������

  /* ���� ������ - �������� ������� ������� ������ */
  type TCOL_VAL is record
  (
    SVALUE                  PKG_STD.TLSTRING, -- �������� (������)
    NVALUE                  PKG_STD.TNUMBER,  -- �������� (�����)
    DVALUE                  PKG_STD.TLDATE    -- �������� (����)
  );
  
  /* ���� ������ - ��������� �������� ������� ������� ������ */
  type TCOL_VALS is table of TCOL_VAL;
 
  /* ���� ������ - ��������� ������� ������� ������ */
  type TCOL_DEF is record
  (
    SNAME                   PKG_STD.TSTRING, -- ������������
    SCAPTION                PKG_STD.TSTRING, -- ���������
    SDATA_TYPE              PKG_STD.TSTRING, -- ��� ������ (��. ��������� SDATA_TYPE_*)
    SCOND_FROM              PKG_STD.TSTRING, -- ������������ ������ ������� ������� ������
    SCOND_TO                PKG_STD.TSTRING, -- ������������ ������� ������� ������� ������
    BVISIBLE                boolean,         -- ��������� �����������
    BORDER                  boolean,         -- ��������� ����������
    BFILTER                 boolean,         -- ��������� �����
    RCOL_VALS               TCOL_VALS        -- ��������������� ��������
  );
  
  /* ���� ������ - ��������� ���������� ������� ������� ������ */
  type TCOL_DEFS is table of TCOL_DEF;
  
  /* ���� ������ - ������� */
  type TCOL is record
  (
    SNAME                   PKG_STD.TSTRING, -- ������������
    RCOL_VAL                TCOL_VAL         -- ��������
  );

  /* ���� ������ - ��������� ������� */
  type TCOLS is table of TCOL;
  
  /* ���� ������ - ������ */
  type TROW is record
  (
    RCOLS                   TCOLS       -- �������
  );
  
  /* ���� ������ - ��������� ����� */
  type TROWS is table of TROW;
  
  /* ���� ������ - ������� ������ */
  type TDATA_GRID is record
  (
    RCOL_DEFS               TCOL_DEFS,  -- �������� �������
    RROWS                   TROWS       -- ������ �����
  );
  
  /* ���� ������ - ������ */
  type TFILTER is record
  (
    SNAME                   PKG_STD.TSTRING, -- ������������
    SFROM                   PKG_STD.TSTRING, -- �������� "�"
    STO                     PKG_STD.TSTRING  -- �������� "��"
  );
  
  /* ���� ������ - ��������� �������� */
  type TFILTERS is table of TFILTER;
  
  /* ���� ������ - ���������� */
  type TORDER is record
  (
    SNAME                   PKG_STD.TSTRING, -- ������������
    SDIRECTION              PKG_STD.TSTRING  -- ����������� (��. ��������� SORDER_DIRECTION_*)
  );
  
  /* ���� ������ - ��������� ���������� */
  type TORDERS is table of TORDER;
  
  /* ������ �������� ���������� ������� */
  procedure UTL_ROWS_LIMITS_CALC
  (
    NPAGE_NUMBER            in number,  -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- ���������� ������� �� �������� (0 - ���)
    NROW_FROM               out number, -- ������ ������� ���������
    NROW_TO                 out number  -- ������� ������� ���������
  );
  
  /* ������������ ������������ ������� ������ ��� ������ ������� */
  function UTL_COND_NAME_MAKE_FROM
  (
    SNAME                   in varchar2 -- ������������ �������
  ) return                  varchar2;   -- ���������
  
  /* ������������ ������������ ������� ������ ��� ������� ������� */
  function UTL_COND_NAME_MAKE_TO
  (
    SNAME                   in varchar2 -- ������������ �������
  ) return                  varchar2;   -- ���������
  
  /* ���������� �������� � ��������� */
  procedure TCOL_VALS_ADD
  (
    RCOL_VALS               in out nocopy TCOL_VALS, -- ��������� ��������
    SVALUE                  in varchar2 := null,     -- �������� (������)
    NVALUE                  in number := null,       -- �������� (�����)
    DVALUE                  in date := null,         -- �������� (����)
    BCLEAR                  in boolean := false      -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  );
  
  /* ������������ ������ */
  function TROW_MAKE
  return                    TROW;       -- ��������� ������
  
  /* ���������� ������� � ������ */
  procedure TROW_ADD_COL
  (
    RROW                    in out nocopy TROW,  -- ������
    SNAME                   in varchar2,         -- ������������ �������
    SVALUE                  in varchar2 := null, -- �������� (������)
    NVALUE                  in number := null,   -- �������� (�����)
    DVALUE                  in date := null,     -- �������� (����)
    BCLEAR                  in boolean := false  -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  );
  
  /* ���������� ��������� ������� � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLS
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  );
  
  /* ���������� �������� ������� � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLN
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  );

  /* ���������� ������� ���� "����" � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLD
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  );
  
  /* ������������ ������� ������ */
  function TDATA_GRID_MAKE
  return                    TDATA_GRID; -- ��������� ������
  
  /* ����� �������� ������� � ������� ������ �� ������������ */
  function TDATA_GRID_FIND_COL_DEF
  (
    RDATA_GRID              in TDATA_GRID, -- �������� ������� ������
    SNAME                   in varchar2    -- ������������ �������
  ) return                  TCOL_DEF;      -- ��������� �������� (null - ���� �� �����)
  
  /* ���������� �������� ������� � ������� ������ */
  procedure TDATA_GRID_ADD_COL_DEF
  (
    RDATA_GRID              in out nocopy TDATA_GRID,      -- �������� ������� ������
    SNAME                   in varchar2,                   -- ������������ �������
    SCAPTION                in varchar2,                   -- ��������� �������
    SDATA_TYPE              in varchar2 := SDATA_TYPE_STR, -- ��� ������ ������� (��. ��������� SDATA_TYPE_*)
    SCOND_FROM              in varchar2 := null,           -- ������������ ������ ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_FROM)
    SCOND_TO                in varchar2 := null,           -- ������������ ������� ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_TO)
    BVISIBLE                in boolean := true,            -- ��������� �����������
    BORDER                  in boolean := false,           -- ��������� ���������� �� �������
    BFILTER                 in boolean := false,           -- ��������� ����� �� �������
    RCOL_VALS               in TCOL_VALS := null,          -- ��������������� �������� �������
    BCLEAR                  in boolean := false            -- ���� ������� ��������� �������� ������� ������� ������ (false - �� �������, true - �������� ��������� ����� �����������)
  );
  
  /* ���������� �������� ������� � ������� ������ */
  procedure TDATA_GRID_ADD_ROW
  (
    RDATA_GRID              in out nocopy TDATA_GRID, -- �������� ������� ������
    RROW                    in TROW,                  -- ������
    BCLEAR                  in boolean := false       -- ���� ������� ��������� ����� ������� ������ (false - �� �������, true - �������� ��������� ����� �����������)
  );

  /* ������������ ������� ������ */
  function TDATA_GRID_TO_XML
  (
    RDATA_GRID              in TDATA_GRID, -- �������� ������� ������
    NINCLUDE_DEF            in number := 1 -- �������� �������� ������� (0 - ���, 1 - ��)
  ) return                  clob;          -- XML-��������

  
  /* ����������� �������� ������� � ����� */
  procedure TFILTER_TO_NUMBER
  (
    RFILTER                 in TFILTER, -- ������
    NFROM                   out number, -- �������� ������ ������� ���������
    NTO                     out number  -- �������� ������� ������� ���������
  );

  /* ����������� �������� ������� � ���� */
  procedure TFILTER_TO_DATE
  (
    RFILTER                 in TFILTER, -- ������
    DFROM                   out date,   -- �������� ������ ������� ���������
    DTO                     out date    -- �������� ������� ������� ���������
  );
  
  /* ����� ������� � ��������� */
  function TFILTERS_FIND
  (
    RFILTERS                in TFILTERS, -- ��������� ��������
    SNAME                   in varchar2  -- ������������
  ) return                  TFILTER;     -- ��������� ������ (null - ���� �� �����)
  
  /* �������������� �������� */
  function TFILTERS_FROM_XML
  (
    CFILTERS                in clob     -- ��������������� ������������� �������� (BASE64(<filters><name>���</name><from>��������</from><to>��������</to></filters>...))
  ) return                  TFILTERS;   -- ��������� ������

  /* ���������� ���������� ���������� � ������� */
  procedure TFILTERS_SET_QUERY
  (
    NIDENT                  in number,         -- ������������� ������
    NCOMPANY                in number,         -- ���. ����� �����������
    NPARENT                 in number := null, -- ���. ����� ��������
    SUNIT                   in varchar2,       -- ��� �������
    SPROCEDURE              in varchar2,       -- ������������ ��������� ��������� ������
    RDATA_GRID              in TDATA_GRID,     -- �������� ������� ������
    RFILTERS                in TFILTERS        -- ��������� ��������
  );
  
  /* �������������� ���������� */
  function TORDERS_FROM_XML
  (
    CORDERS                 in clob     -- ��������������� ������������� ���������� (BASE64(<orders><name>���</name><direction>ASC/DESC</direction></orders>...))
  ) return                  TORDERS;    -- ��������� ������

  /* ���������� ���������� ���������� � ������� */
  procedure TORDERS_SET_QUERY
  (
    RDATA_GRID              in TDATA_GRID,     -- �������� �������
    RORDERS                 in TORDERS,        -- ��������� ����������
    SPATTERN                in varchar2,       -- ������ ��� ����������� ������� ������ � ������
    CSQL                    in out nocopy clob -- ����� �������
  );

end PKG_P8PANELS_VISUAL;
/
create or replace package body PKG_P8PANELS_VISUAL as

  /* ��������� - ���� �������� */
  SRQ_TAG_XROOT           constant PKG_STD.TSTRING := 'XROOT';     -- ��� ��� ����� ������ �������
  SRQ_TAG_XFILTERS        constant PKG_STD.TSTRING := 'filters';   -- ��� ��� ����� ������
  SRQ_TAG_XORDERS         constant PKG_STD.TSTRING := 'orders';    -- ��� ��� �������� �������
  SRQ_TAG_SNAME           constant PKG_STD.TSTRING := 'name';      -- ��� ��� ������������
  SRQ_TAG_SDIRECTION      constant PKG_STD.TSTRING := 'direction'; -- ��� ��� �����������
  SRQ_TAG_SFROM           constant PKG_STD.TSTRING := 'from';      -- ��� ��� �������� "�"
  SRQ_TAG_STO             constant PKG_STD.TSTRING := 'to';        -- ��� ��� �������� "��"

  /* ��������� - ���� ������� */
  SRESP_TAG_XDATA           constant PKG_STD.TSTRING := 'XDATA';        -- ��� ��� ����� �������� ������
  SRESP_TAG_XROWS           constant PKG_STD.TSTRING := 'XROWS';        -- ��� ��� ����� ������
  SRESP_TAG_XCOLUMNS_DEF    constant PKG_STD.TSTRING := 'XCOLUMNS_DEF'; -- ��� ��� �������� �������

  /* ��������� - �������� ������� */
  SRESP_ATTR_NAME           constant PKG_STD.TSTRING := 'name';     -- ������� ��� ������������
  SRESP_ATTR_CAPTION        constant PKG_STD.TSTRING := 'caption';  -- ������� ��� �������
  SRESP_ATTR_DATA_TYPE      constant PKG_STD.TSTRING := 'dataType'; -- ������� ��� ���� ������
  SRESP_ATTR_VISIBLE        constant PKG_STD.TSTRING := 'visible';  -- ������� ��� ����� ���������
  SRESP_ATTR_ORDER          constant PKG_STD.TSTRING := 'order';    -- ������� ��� ����� ����������
  SRESP_ATTR_FILTER         constant PKG_STD.TSTRING := 'filter';   -- ������� ��� ����� ������
  SRESP_ATTR_VALUES         constant PKG_STD.TSTRING := 'values';   -- ������� ��� ��������
  
  /* ��������� - ��������� ������� ������ */
  SCOND_FROM_POSTFIX        constant PKG_STD.TSTRING := 'From'; -- �������� ������������ ������ ������� ������� ������
  SCOND_TO_POSTFIX          constant PKG_STD.TSTRING := 'To';   -- �������� ������������ ������� ������� ������� ������

  /* ������ �������� ���������� ������� */
  procedure UTL_ROWS_LIMITS_CALC
  (
    NPAGE_NUMBER            in number,  -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- ���������� ������� �� �������� (0 - ���)
    NROW_FROM               out number, -- ������ ������� ���������
    NROW_TO                 out number  -- ������� ������� ���������
  )
  is
  begin
    if (COALESCE(NPAGE_SIZE, 0) <= 0)
    then
      NROW_FROM := 1;
      NROW_TO   := 1000000000;
    else
      NROW_FROM := COALESCE(NPAGE_NUMBER, 1) * NPAGE_SIZE - NPAGE_SIZE + 1;
      NROW_TO   := COALESCE(NPAGE_NUMBER, 1) * NPAGE_SIZE;
    end if;
  end UTL_ROWS_LIMITS_CALC;
  
  /* ������������ ������������ ������� ������ ��� ������ ������� */
  function UTL_COND_NAME_MAKE_FROM
  (
    SNAME                   in varchar2 -- ������������ �������
  ) return                  varchar2    -- ���������
  is
  begin
    return SNAME || SCOND_FROM_POSTFIX;
  end UTL_COND_NAME_MAKE_FROM;

  /* ������������ ������������ ������� ������ ��� ������� ������� */
  function UTL_COND_NAME_MAKE_TO
  (
    SNAME                   in varchar2 -- ������������ �������
  ) return                  varchar2    -- ���������
  is
  begin
    return SNAME || SCOND_TO_POSTFIX;
  end UTL_COND_NAME_MAKE_TO;
  
  /* ������������ �������� */
  function TCOL_VAL_MAKE
  (
    SVALUE                  in varchar2, -- �������� (������)
    NVALUE                  in number,   -- �������� (�����)
    DVALUE                  in date      -- �������� (����)
  ) return                  TCOL_VAL     -- ��������� ������
  is
    RRES                    TCOL_VAL;    -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.SVALUE := SVALUE;
    RRES.NVALUE := NVALUE;
    RRES.DVALUE := DVALUE;
    /* ���������� ��������� */
    return RRES;
  end TCOL_VAL_MAKE;

  /* ���������� �������� � ��������� */
  procedure TCOL_VALS_ADD
  (
    RCOL_VALS               in out nocopy TCOL_VALS, -- ��������� ��������
    SVALUE                  in varchar2 := null,     -- �������� (������)
    NVALUE                  in number := null,       -- �������� (�����)
    DVALUE                  in date := null,         -- �������� (����)
    BCLEAR                  in boolean := false      -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* �������������� ��������� ���� ���������� */
    if ((RCOL_VALS is null) or (BCLEAR)) then
      RCOL_VALS := TCOL_VALS();
    end if;
    /* ��������� ������� */
    RCOL_VALS.EXTEND();
    RCOL_VALS(RCOL_VALS.LAST) := TCOL_VAL_MAKE(SVALUE => SVALUE, NVALUE => NVALUE, DVALUE => DVALUE);
  end TCOL_VALS_ADD;
  
  /* ������������ �������� ������� */
  function TCOL_DEF_MAKE
  (
    SNAME                   in varchar2,                   -- ������������
    SCAPTION                in varchar2,                   -- ���������
    SDATA_TYPE              in varchar2 := SDATA_TYPE_STR, -- ��� ������ (��. ��������� SDATA_TYPE_*)
    SCOND_FROM              in varchar2 := null,           -- ������������ ������ ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_FROM)
    SCOND_TO                in varchar2 := null,           -- ������������ ������� ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_TO)
    BVISIBLE                in boolean := true,            -- ��������� �����������
    BORDER                  in boolean := false,           -- ��������� ����������
    BFILTER                 in boolean := false,           -- ��������� �����
    RCOL_VALS               in TCOL_VALS := null           -- ��������������� ��������
  ) return                  TCOL_DEF                       -- ��������� ������
  is
    RRES                    TCOL_DEF;                      -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.SNAME      := SNAME;
    RRES.SCAPTION   := SCAPTION;
    RRES.SDATA_TYPE := COALESCE(SDATA_TYPE, SDATA_TYPE_STR);
    RRES.SCOND_FROM := COALESCE(SCOND_FROM, UTL_COND_NAME_MAKE_FROM(SNAME => SNAME));
    RRES.SCOND_TO   := COALESCE(SCOND_TO, UTL_COND_NAME_MAKE_TO(SNAME => SNAME));
    RRES.BVISIBLE   := COALESCE(BVISIBLE, true);
    RRES.BORDER     := COALESCE(BORDER, false);
    RRES.BFILTER    := COALESCE(BFILTER, false);
    RRES.RCOL_VALS  := COALESCE(RCOL_VALS, TCOL_VALS());
    /* ���������� ��������� */
    return RRES;
  end TCOL_DEF_MAKE;
  
  /* ���������� �������� ������� � ��������� */
  procedure TCOL_DEFS_ADD
  (
    RCOL_DEFS               in out nocopy TCOL_DEFS,       -- ��������� �������� �������
    SNAME                   in varchar2,                   -- ������������
    SCAPTION                in varchar2,                   -- ���������
    SDATA_TYPE              in varchar2 := SDATA_TYPE_STR, -- ��� ������ (��. ��������� SDATA_TYPE_*)
    SCOND_FROM              in varchar2 := null,           -- ������������ ������ ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_FROM)
    SCOND_TO                in varchar2 := null,           -- ������������ ������� ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_TO)
    BVISIBLE                in boolean := true,            -- ��������� �����������
    BORDER                  in boolean := false,           -- ��������� ����������
    BFILTER                 in boolean := false,           -- ��������� �����
    RCOL_VALS               in TCOL_VALS := null,          -- ��������������� ��������
    BCLEAR                  in boolean := false            -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* �������������� ��������� ���� ���������� */
    if ((RCOL_DEFS is null) or (BCLEAR)) then
      RCOL_DEFS := TCOL_DEFS();
    end if;
    /* ��������� ������� */
    RCOL_DEFS.EXTEND();
    RCOL_DEFS(RCOL_DEFS.LAST) := TCOL_DEF_MAKE(SNAME      => SNAME,
                                               SCAPTION   => SCAPTION,
                                               SDATA_TYPE => SDATA_TYPE,
                                               SCOND_FROM => SCOND_FROM,
                                               SCOND_TO   => SCOND_TO,
                                               BVISIBLE   => BVISIBLE,
                                               BORDER     => BORDER,
                                               BFILTER    => BFILTER,
                                               RCOL_VALS  => RCOL_VALS);
  end TCOL_DEFS_ADD;
  
  /* ����� �������� ������� �� ������������ */
  function TCOL_DEFS_FIND
  (
    RCOL_DEFS               in TCOL_DEFS, -- �������� ������� ������� ������
    SNAME                   in varchar2   -- ������������
  ) return                  TCOL_DEF      -- ��������� �������� (null - ���� �� �����)
  is
  begin
    /* ������� ������� �� ��������� �������� */
    if ((RCOL_DEFS is not null) and (RCOL_DEFS.COUNT > 0)) then
      for I in RCOL_DEFS.FIRST .. RCOL_DEFS.LAST
      loop
        if (RCOL_DEFS(I).SNAME = SNAME) then
          return RCOL_DEFS(I);
        end if;
      end loop;
    end if;
    /* ������ �� ����� */
    return null;
  end TCOL_DEFS_FIND;
  
  /* ������������ �������� ������� ������� ������ */
  procedure TCOL_DEFS_TO_XML
  (
    RCOL_DEFS               in TCOL_DEFS -- �������� ������� ������� ������
  )
  is    
  begin
    /* ������� ������� �� ��������� */
    if ((RCOL_DEFS is not null) and (RCOL_DEFS.COUNT > 0)) then
      for I in RCOL_DEFS.FIRST .. RCOL_DEFS.LAST
      loop
        /* ��������� �������� ������� */
        PKG_XFAST.DOWN_NODE(SNAME => SRESP_TAG_XCOLUMNS_DEF);
        /* �������� ������� */
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_NAME, SVALUE => RCOL_DEFS(I).SNAME);
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_CAPTION, SVALUE => RCOL_DEFS(I).SCAPTION);
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_DATA_TYPE, SVALUE => RCOL_DEFS(I).SDATA_TYPE);
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_VISIBLE, BVALUE => RCOL_DEFS(I).BVISIBLE);
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_ORDER, BVALUE => RCOL_DEFS(I).BORDER);
        PKG_XFAST.ATTR(SNAME => SRESP_ATTR_FILTER, BVALUE => RCOL_DEFS(I).BFILTER);
        /* ��������������� �������� */
        if (RCOL_DEFS(I).RCOL_VALS is not null) and (RCOL_DEFS(I).RCOL_VALS.COUNT > 0) then
          for V in RCOL_DEFS(I).RCOL_VALS.FIRST .. RCOL_DEFS(I).RCOL_VALS.LAST
          loop
            /* ��������� �������� ���������������� �������� */
            PKG_XFAST.DOWN_NODE(SNAME => SRESP_ATTR_VALUES);
            /* �������� */
            case RCOL_DEFS(I).SDATA_TYPE
              when SDATA_TYPE_STR then
                PKG_XFAST.VALUE(SVALUE => RCOL_DEFS(I).RCOL_VALS(V).SVALUE);
              when SDATA_TYPE_NUMB then
                PKG_XFAST.VALUE(NVALUE => RCOL_DEFS(I).RCOL_VALS(V).NVALUE);
              when SDATA_TYPE_DATE then
                PKG_XFAST.VALUE(DVALUE => RCOL_DEFS(I).RCOL_VALS(V).DVALUE);
              else
                P_EXCEPTION(0,
                            '�������� ������� "%s" ������� ������ �������� ���������������� ��� ������ ("%s").',
                            COALESCE(RCOL_DEFS(I).SNAME, '<�� ����������>'),
                            COALESCE(RCOL_DEFS(I).SDATA_TYPE, '<�� ������˨�>'));
            end case;
            /* ��������� �������� ���������������� �������� */
            PKG_XFAST.UP();          
          end loop;
        end if;
        /* ��������� �������� ������� */
        PKG_XFAST.UP();
      end loop;
    end if;
  end TCOL_DEFS_TO_XML;
  
  /* ������������ ������� */
  function TCOL_MAKE
  (
    SNAME                   in varchar2,         -- ������������ �������
    SVALUE                  in varchar2 := null, -- �������� (������)
    NVALUE                  in number := null,   -- �������� (�����)
    DVALUE                  in date := null      -- �������� (����)
  ) return                  TCOL                 -- ��������� ������
  is
    RRES                    TCOL;                -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.SNAME    := SNAME;
    RRES.RCOL_VAL := TCOL_VAL_MAKE(SVALUE => SVALUE, NVALUE => NVALUE, DVALUE => DVALUE);
    /* ���������� ��������� */
    return RRES;
  end TCOL_MAKE;
  
  /* ���������� ������� � ��������� */
  procedure TCOLS_ADD
  (
    RCOLS                   in out nocopy TCOLS, -- ��������� �������
    SNAME                   in varchar2,         -- ������������ �������
    SVALUE                  in varchar2 := null, -- �������� (������)
    NVALUE                  in number := null,   -- �������� (�����)
    DVALUE                  in date := null,     -- �������� (����)
    BCLEAR                  in boolean := false  -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* �������������� ��������� ���� ���������� */
    if ((RCOLS is null) or (BCLEAR)) then
      RCOLS := TCOLS();
    end if;
    /* ��������� ������� */
    RCOLS.EXTEND();
    RCOLS(RCOLS.LAST) := TCOL_MAKE(SNAME => SNAME, SVALUE => SVALUE, NVALUE => NVALUE, DVALUE => DVALUE);
  end TCOLS_ADD;
  
  /* ������������ ������ */
  function TROW_MAKE
  return                    TROW        -- ��������� ������
  is
    RRES                    TROW;       -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.RCOLS := TCOLS();
    /* ���������� ��������� */
    return RRES;
  end TROW_MAKE;
  
  /* ���������� ������� � ������ */
  procedure TROW_ADD_COL
  (
    RROW                    in out nocopy TROW,  -- ������
    SNAME                   in varchar2,         -- ������������ �������
    SVALUE                  in varchar2 := null, -- �������� (������)
    NVALUE                  in number := null,   -- �������� (�����)
    DVALUE                  in date := null,     -- �������� (����)
    BCLEAR                  in boolean := false  -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* ���������� ������� � ������� � � ��������� ������� ������ */
    TCOLS_ADD(RCOLS => RROW.RCOLS, SNAME => SNAME, SVALUE => SVALUE, NVALUE => NVALUE, DVALUE => DVALUE, BCLEAR => BCLEAR);
  end TROW_ADD_COL;
  
  /* ���������� ��������� ������� � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLS
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
    SVALUE                  PKG_STD.TLSTRING;   -- ����� ��� �������� �������
  begin
    /* ������ ������ �� ������� */
    PKG_SQL_DML.COLUMN_VALUE_STR(ICURSOR => ICURSOR, IPOSITION => NPOSITION, SVALUE => SVALUE);
    /* ���������� ������� � ������� � � ��������� ������� ������ */
    TCOLS_ADD(RCOLS => RROW.RCOLS, SNAME => SNAME, SVALUE => SVALUE, NVALUE => null, DVALUE => null, BCLEAR => BCLEAR);
  end TROW_ADD_CUR_COLS;

  /* ���������� �������� ������� � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLN
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
    NVALUE                  PKG_STD.TNUMBER;    -- ����� ��� �������� �������
  begin
    /* ������ ������ �� ������� */
    PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => NPOSITION, NVALUE => NVALUE);
    /* ���������� ������� � ������� � � ��������� ������� ������ */
    TCOLS_ADD(RCOLS => RROW.RCOLS, SNAME => SNAME, SVALUE => null, NVALUE => NVALUE, DVALUE => null, BCLEAR => BCLEAR);
  end TROW_ADD_CUR_COLN;
  
  /* ���������� ������� ���� "����" � ������ �� ������� ������������� ������� */
  procedure TROW_ADD_CUR_COLD
  (
    RROW                    in out nocopy TROW, -- ������
    SNAME                   in varchar2,        -- ������������ �������
    ICURSOR                 in integer,         -- ������
    NPOSITION               in number,          -- ����� ������� � �������
    BCLEAR                  in boolean := false -- ���� ������� ��������� (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
    DVALUE                  PKG_STD.TLDATE;     -- ����� ��� �������� �������
  begin
    /* ������ ������ �� ������� */
    PKG_SQL_DML.COLUMN_VALUE_DATE(ICURSOR => ICURSOR, IPOSITION => NPOSITION, DVALUE => DVALUE);
    /* ���������� ������� � ������� � � ��������� ������� ������ */
    TCOLS_ADD(RCOLS => RROW.RCOLS, SNAME => SNAME, SVALUE => null, NVALUE => null, DVALUE => DVALUE, BCLEAR => BCLEAR);
  end TROW_ADD_CUR_COLD;
  
  /* ������������ ������ ������ ������� ������ */
  procedure TROWS_TO_XML
  (
    RCOL_DEFS               in TCOL_DEFS, -- �������� ������� ������� ������
    RROWS                   in TROWS      -- ������ ������� ������
  )
  is  
    RCOL_DEF                TCOL_DEF;     -- �������� ������� ������������� �������
  begin
    /* ������� ������ �� ��������� */
    if ((RROWS is not null) and (RROWS.COUNT > 0)) then
      for I in RROWS.FIRST .. RROWS.LAST
      loop
        /* ��������� ������ */
        PKG_XFAST.DOWN_NODE(SNAME => SRESP_TAG_XROWS);
        /* ������� ������� ������ */
        if ((RROWS(I).RCOLS is not null) and (RROWS(I).RCOLS.COUNT > 0)) then
          for J in RROWS(I).RCOLS.FIRST .. RROWS(I).RCOLS.LAST
          loop
            /* ����� �������� ������� */
            RCOL_DEF := TCOL_DEFS_FIND(RCOL_DEFS => RCOL_DEFS, SNAME => RROWS(I).RCOLS(J).SNAME);
            if (RCOL_DEF.SNAME is null) then
              P_EXCEPTION(0,
                          '�������� ������� "%s" ������� ������ �� ����������.',
                          RROWS(I).RCOLS(J).SNAME);
            end if;
            /* ����������� �������� ������� ��� ������� ������ */
            case RCOL_DEF.SDATA_TYPE
              when SDATA_TYPE_STR then
                PKG_XFAST.ATTR(SNAME => RROWS(I).RCOLS(J).SNAME, SVALUE => RROWS(I).RCOLS(J).RCOL_VAL.SVALUE);
              when SDATA_TYPE_NUMB then
                PKG_XFAST.ATTR(SNAME => RROWS(I).RCOLS(J).SNAME, NVALUE => RROWS(I).RCOLS(J).RCOL_VAL.NVALUE);
              when SDATA_TYPE_DATE then
                PKG_XFAST.ATTR(SNAME => RROWS(I).RCOLS(J).SNAME, DVALUE => RROWS(I).RCOLS(J).RCOL_VAL.DVALUE);
              else
                P_EXCEPTION(0,
                            '�������� ������� "%s" ������� ������ �������� ���������������� ��� ������ ("%s").',
                            RCOL_DEFS(I).SNAME,
                            COALESCE(RCOL_DEFS(I).SDATA_TYPE, '<�� ������˨�>'));
            end case;
          end loop;
        end if;
        /* ��������� ������ */
        PKG_XFAST.UP();
      end loop;
    end if;
  end TROWS_TO_XML;
  
  /* ������������ ������� ������ */
  function TDATA_GRID_MAKE
  return                    TDATA_GRID  -- ��������� ������
  is
    RRES                    TDATA_GRID; -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.RCOL_DEFS := TCOL_DEFS();
    RRES.RROWS     := TROWS();
    /* ���������� ��������� */
    return RRES;
  end TDATA_GRID_MAKE;
  
  /* ����� �������� ������� � ������� ������ �� ������������ */
  function TDATA_GRID_FIND_COL_DEF
  (
    RDATA_GRID              in TDATA_GRID, -- �������� ������� ������
    SNAME                   in varchar2    -- ������������ �������
  ) return                  TCOL_DEF       -- ��������� �������� (null - ���� �� �����)
  is
  begin
    return TCOL_DEFS_FIND(RCOL_DEFS => RDATA_GRID.RCOL_DEFS, SNAME => SNAME);
  end TDATA_GRID_FIND_COL_DEF;
  
  /* ���������� �������� ������� � ������� ������ */
  procedure TDATA_GRID_ADD_COL_DEF
  (
    RDATA_GRID              in out nocopy TDATA_GRID,      -- �������� ������� ������
    SNAME                   in varchar2,                   -- ������������ �������
    SCAPTION                in varchar2,                   -- ��������� �������
    SDATA_TYPE              in varchar2 := SDATA_TYPE_STR, -- ��� ������ ������� (��. ��������� SDATA_TYPE_*)
    SCOND_FROM              in varchar2 := null,           -- ������������ ������ ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_FROM)
    SCOND_TO                in varchar2 := null,           -- ������������ ������� ������� ������� ������ (null - ������������ UTL_COND_NAME_MAKE_TO)
    BVISIBLE                in boolean := true,            -- ��������� �����������
    BORDER                  in boolean := false,           -- ��������� ���������� �� �������
    BFILTER                 in boolean := false,           -- ��������� ����� �� �������
    RCOL_VALS               in TCOL_VALS := null,          -- ��������������� �������� �������
    BCLEAR                  in boolean := false            -- ���� ������� ��������� �������� ������� ������� ������ (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* ��������� �������� � ��������� � ��������� ������� ������ */
    TCOL_DEFS_ADD(RCOL_DEFS  => RDATA_GRID.RCOL_DEFS,
                  SNAME      => SNAME,
                  SCAPTION   => SCAPTION,
                  SDATA_TYPE => SDATA_TYPE,
                  SCOND_FROM => SCOND_FROM,
                  SCOND_TO   => SCOND_TO,
                  BVISIBLE   => BVISIBLE,
                  BORDER     => BORDER,
                  BFILTER    => BFILTER,
                  RCOL_VALS  => RCOL_VALS,
                  BCLEAR     => BCLEAR);
  end TDATA_GRID_ADD_COL_DEF;
  
  /* ���������� �������� ������� � ������� ������ */
  procedure TDATA_GRID_ADD_ROW
  (
    RDATA_GRID              in out nocopy TDATA_GRID, -- �������� ������� ������
    RROW                    in TROW,                  -- ������
    BCLEAR                  in boolean := false       -- ���� ������� ��������� ����� ������� ������ (false - �� �������, true - �������� ��������� ����� �����������)
  )
  is
  begin
    /* �������������� ��������� ���� ���������� */
    if ((RDATA_GRID.RROWS is null) or (BCLEAR)) then
      RDATA_GRID.RROWS := TROWS();
    end if;
    /* ��������� ������� */
    RDATA_GRID.RROWS.EXTEND();
    RDATA_GRID.RROWS(RDATA_GRID.RROWS.LAST) := RROW;
  end TDATA_GRID_ADD_ROW;
  
  /* ������������ ������� ������ */
  function TDATA_GRID_TO_XML
  (
    RDATA_GRID              in TDATA_GRID, -- �������� ������� ������
    NINCLUDE_DEF            in number := 1 -- �������� �������� ������� (0 - ���, 1 - ��)
  ) return                  clob           -- XML-��������
  is
    CRES                    clob;          -- ����� ��� ����������
  begin
    /* �������� ������������ XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* ��������� ������ */
    PKG_XFAST.DOWN_NODE(SNAME => SRESP_TAG_XDATA);
    /* ���� ���������� �������� �������� ������� */
    if (NINCLUDE_DEF = 1) then
      TCOL_DEFS_TO_XML(RCOL_DEFS => RDATA_GRID.RCOL_DEFS);
    end if;
    /* ��������� �������� ����� */
    TROWS_TO_XML(RCOL_DEFS => RDATA_GRID.RCOL_DEFS,RROWS => RDATA_GRID.RROWS);
    /* ��������� ������ */
    PKG_XFAST.UP();
    /* ����������� */
    CRES := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* ��������� ������������ XML */
    PKG_XFAST.EPILOGUE();
    /* ���������� ���������� */
    return CRES;
  exception
    when others then
      /* ��������� ������������ XML */
      PKG_XFAST.EPILOGUE();
      /* ������ ������ */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end TDATA_GRID_TO_XML;
  
  /* ����������� �������� ������� � ����� */
  procedure TFILTER_TO_NUMBER
  (
    RFILTER                 in TFILTER, -- ������
    NFROM                   out number, -- �������� ������ ������� ���������
    NTO                     out number  -- �������� ������� ������� ���������
  )
  is
  begin
    /* ������ ������� ��������� */
    if (RFILTER.SFROM is not null) then
      begin
        NFROM := PKG_P8PANELS_BASE.UTL_S2N(SVALUE => RFILTER.SFROM);
      exception
        when others then
          P_EXCEPTION(0,
                      '�������� ������ ����� (%s) � ��������� ������ ������� ��������� �������.',
                      RFILTER.SFROM);
      end;
    end if;
    /* ������� ������� ��������� */    
    if (RFILTER.STO is not null) then
      begin
        NTO := PKG_P8PANELS_BASE.UTL_S2N(SVALUE => RFILTER.STO);
      exception
        when others then
          P_EXCEPTION(0,
                      '�������� ������ ����� (%s) � ��������� ������� ������� ��������� �������.',
                      RFILTER.STO);
      end;
    end if;
  end TFILTER_TO_NUMBER;
  
  /* ����������� �������� ������� � ���� */
  procedure TFILTER_TO_DATE
  (
    RFILTER                 in TFILTER, -- ������
    DFROM                   out date,   -- �������� ������ ������� ���������
    DTO                     out date    -- �������� ������� ������� ���������
  )
  is
  begin
    /* ������ ������� ��������� */
    if (RFILTER.SFROM is not null) then
      begin
        DFROM := PKG_P8PANELS_BASE.UTL_S2D(SVALUE => RFILTER.SFROM);
      exception
        when others then
          P_EXCEPTION(0,
                      '�������� ������ ���� (%s) � ��������� ������ ������� ��������� �������.',
                      RFILTER.SFROM);
      end;
    end if;
    /* ������� ������� ��������� */
    if (RFILTER.STO is not null) then
      begin
        DTO := PKG_P8PANELS_BASE.UTL_S2D(SVALUE => RFILTER.STO);
      exception
        when others then
          P_EXCEPTION(0,
                      '�������� ������ ���� (%s) � ��������� ������� ������� ��������� �������.',
                      RFILTER.STO);
      end;
    end if;
  end TFILTER_TO_DATE;

  /* ������������ ������� */
  function TFILTER_MAKE
  (
    SNAME                   in varchar2, -- ������������
    SFROM                   in varchar2, -- �������� "�"
    STO                     in varchar2  -- �������� "��"
  ) return                  TFILTER      -- ��������� ������
  is
    RRES                    TFILTER;    -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.SNAME := SNAME;
    RRES.SFROM := SFROM;
    RRES.STO   := STO;
    /* ���������� ��������� */
    return RRES;
  end TFILTER_MAKE;
  
  /* ����� ������� � ��������� */
  function TFILTERS_FIND
  (
    RFILTERS                in TFILTERS, -- ��������� ��������
    SNAME                   in varchar2  -- ������������
  ) return                  TFILTER      -- ��������� ������ (null - ���� �� �����)
  is
  begin
    /* ������� ������� �� ��������� */
    if ((RFILTERS is not null) and (RFILTERS.COUNT > 0)) then
      for I in RFILTERS.FIRST .. RFILTERS.LAST
      loop
        if (RFILTERS(I).SNAME = SNAME) then
          return RFILTERS(I);
        end if;
      end loop;
    end if;
    /* ������ �� ����� */
    return null;
  end TFILTERS_FIND;
  
  /* �������������� �������� */
  function TFILTERS_FROM_XML
  (
    CFILTERS                in clob              -- ��������������� ������������� �������� (BASE64(<filters><name>���</name><from>��������</from><to>��������</to></filters>...))
  ) return                  TFILTERS             -- ��������� ������
  is
    RFILTERS                TFILTERS;            -- ����� ��� ���������� ������
    XDOC                    PKG_XPATH.TDOCUMENT; -- �������� XML
    XROOT                   PKG_XPATH.TNODE;     -- ������ ��������� XML
    XNODE                   PKG_XPATH.TNODE;     -- ����� ���� ���������
    XNODES                  PKG_XPATH.TNODES;    -- ����� ��������� ����� ���������
  begin
    /* ����� �������� ��������� */
    RFILTERS := TFILTERS();
    /* ��������� XML */
    XDOC := PKG_XPATH.PARSE_FROM_CLOB(LCXML => '<' || SRQ_TAG_XROOT || '>' ||
                                               BLOB2CLOB(LBDATA   => BASE64_DECODE(LCSRCE => CFILTERS),
                                                         SCHARSET => PKG_CHARSET.CHARSET_UTF_()) || '</' ||
                                               SRQ_TAG_XROOT || '>');
    /* ��������� �������� ���� */
    XROOT := PKG_XPATH.ROOT_NODE(RDOCUMENT => XDOC);
    /* ���������� ������ ������� */
    XNODES := PKG_XPATH.LIST_NODES(RPARENT_NODE => XROOT, SPATTERN => '/' || SRQ_TAG_XROOT || '/' || SRQ_TAG_XFILTERS);
    /* ���� �� ������ �������� */
    for I in 1 .. PKG_XPATH.COUNT_NODES(RNODES => XNODES)
    loop
      /* ������� ������� �� ��� ������ */
      XNODE := PKG_XPATH.ITEM_NODE(RNODES => XNODES, INUMBER => I);
      /* ������� ��� � ��������� */
      RFILTERS.EXTEND();
      RFILTERS(RFILTERS.LAST) := TFILTER_MAKE(SNAME => PKG_XPATH.VALUE(RNODE => XNODE, SPATTERN => SRQ_TAG_SNAME),
                                              SFROM => PKG_XPATH.VALUE(RNODE => XNODE, SPATTERN => SRQ_TAG_SFROM),
                                              STO   => PKG_XPATH.VALUE(RNODE => XNODE, SPATTERN => SRQ_TAG_STO));
    end loop;
    /* ��������� �������� */
    PKG_XPATH.FREE(RDOCUMENT => XDOC);
    /* ����� ��������� */
    return RFILTERS;
  exception
    when others then
      /* ��������� �������� */
      PKG_XPATH.FREE(RDOCUMENT => XDOC);
      /* ������ ������ */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end TFILTERS_FROM_XML;
  
  /* ���������� ���������� ���������� � ������� */
  procedure TFILTERS_SET_QUERY
  (
    NIDENT                  in number,         -- ������������� ������
    NCOMPANY                in number,         -- ���. ����� �����������
    NPARENT                 in number := null, -- ���. ����� ��������
    SUNIT                   in varchar2,       -- ��� �������
    SPROCEDURE              in varchar2,       -- ������������ ��������� ��������� ������
    RDATA_GRID              in TDATA_GRID,     -- �������� ������� ������
    RFILTERS                in TFILTERS        -- ��������� ��������
  )
  is
    RCOL_DEF                TCOL_DEF;          -- �������� ������� ����������� �������
    BENUM                   boolean;           -- ���� ��������� ������������� ��������
    NFROM                   PKG_STD.TNUMBER;   -- ����� ��� ������� ������� ��������� ������ �����
    NTO                     PKG_STD.TNUMBER;   -- ����� ��� ������ ������� ��������� ������ �����
    DFROM                   PKG_STD.TLDATE;    -- ����� ��� ������� ������� ��������� ������ ���
    DTO                     PKG_STD.TLDATE;    -- ����� ��� ������ ������� ��������� ������ ���
  begin
    /* ������������ ������� ������ - ������ */
    PKG_COND_BROKER.PROLOGUE(IMODE => PKG_COND_BROKER.MODE_SMART_, NIDENT => NIDENT);
    /* ������������ ������� ������ - ��������� ��������� ���������� ������ */
    PKG_COND_BROKER.SET_PROCEDURE(SPROCEDURE_NAME => SPROCEDURE);
    /* ������������ ������� ������ - ��������� ������� */
    PKG_COND_BROKER.SET_UNIT(SUNITCODE => SUNIT);
    /* ������������ ������� ������ - ��������� ����������� */
    PKG_COND_BROKER.SET_COMPANY(NCOMPANY => NCOMPANY);
    /* ������������ ������� ������ - ��������� �������� */
    if (NPARENT is not null) then
      PKG_COND_BROKER.SET_PARENT(NPARENT => NPARENT);
    end if;
    /* ������� ������, ���� ����� */
    if ((RFILTERS is not null) and (RFILTERS.COUNT > 0)) then
      for I in RFILTERS.FIRST .. RFILTERS.LAST
      loop
        /* ������ ����������� ������� � �������� */
        RCOL_DEF := TCOL_DEFS_FIND(RCOL_DEFS => RDATA_GRID.RCOL_DEFS, SNAME => RFILTERS(I).SNAME);
        if (RCOL_DEF.SNAME is not null) then
          /* ����������� � �������� ������������� �������� */
          if ((RCOL_DEF.RCOL_VALS is not null) and (RCOL_DEF.RCOL_VALS.COUNT > 0)) then
            BENUM := true;
          else
            BENUM := false;
          end if;
          /* ��������� ��� �� ������� ������ �������� ���� ������ */
          case RCOL_DEF.SDATA_TYPE
            when SDATA_TYPE_STR then
              begin
                if (BENUM) then
                  PKG_COND_BROKER.SET_CONDITION_ESTR(SCONDITION_NAME   => RCOL_DEF.SCOND_FROM,
                                                     SCONDITION_ESTR   => RFILTERS(I).SFROM,
                                                     ICASE_INSENSITIVE => 1);
                else
                  PKG_COND_BROKER.SET_CONDITION_STR(SCONDITION_NAME   => RCOL_DEF.SCOND_FROM,
                                                    SCONDITION_VALUE  => RFILTERS(I).SFROM,
                                                    ICASE_INSENSITIVE => 1);
                end if;
              end;
            when SDATA_TYPE_NUMB then
              begin
                if (BENUM) then
                  PKG_COND_BROKER.SET_CONDITION_ENUM(SCONDITION_NAME => RCOL_DEF.SCOND_FROM,
                                                     SCONDITION_ENUM => RFILTERS(I).SFROM);
                else
                  TFILTER_TO_NUMBER(RFILTER => RFILTERS(I), NFROM => NFROM, NTO => NTO);
                  if (NFROM is not null) then
                    PKG_COND_BROKER.SET_CONDITION_NUM(SCONDITION_NAME  => RCOL_DEF.SCOND_FROM,
                                                      NCONDITION_VALUE => NFROM);
                  end if;
                  if (NTO is not null) then
                    PKG_COND_BROKER.SET_CONDITION_NUM(SCONDITION_NAME => RCOL_DEF.SCOND_TO, NCONDITION_VALUE => NTO);
                  end if;
                end if;
              end;
            when SDATA_TYPE_DATE then
              begin
                if (BENUM) then                  
                  PKG_COND_BROKER.SET_CONDITION_EDATE(SCONDITION_NAME => RCOL_DEF.SCOND_FROM,
                                                      SCONDITION_EDATE => RFILTERS(I).SFROM);
                else
                  TFILTER_TO_DATE(RFILTER => RFILTERS(I), DFROM => DFROM, DTO => DTO);
                  if (DFROM is not null) then
                    PKG_COND_BROKER.SET_CONDITION_DATE(SCONDITION_NAME  => RCOL_DEF.SCOND_FROM,
                                                       DCONDITION_VALUE => DFROM);
                  end if;
                  if (DTO is not null) then
                    PKG_COND_BROKER.SET_CONDITION_DATE(SCONDITION_NAME => RCOL_DEF.SCOND_TO, DCONDITION_VALUE => DTO);
                  end if;
                end if;
              end;
            else
              P_EXCEPTION(0,
                          '�������� ������� "%s" ������� ������ �������� ���������������� ��� ������ ("%s").',
                          RCOL_DEF.SNAME,
                          COALESCE(RCOL_DEF.SDATA_TYPE, '<�� ������˨�>'));
          end case;
        end if;
      end loop;
    end if;
    /* ������������ ������� ������ - ������ */
    PKG_COND_BROKER.EPILOGUE();
  end TFILTERS_SET_QUERY;
  
  /* ������������ ���������� */
  function TORDER_MAKE
  (
    SNAME                   in varchar2, -- ������������
    SDIRECTION              in varchar2  -- ����������� (��. ��������� SORDER_DIRECTION_*)
  ) return                  TORDER       -- ��������� ������
  is
    RRES                    TORDER;      -- ����� ��� ����������
  begin
    /* ��������� ������ */
    RRES.SNAME      := SNAME;
    RRES.SDIRECTION := SDIRECTION;
    /* ���������� ��������� */
    return RRES;
  end TORDER_MAKE;
  
  /* �������������� ���������� */
  function TORDERS_FROM_XML
  (
    CORDERS                 in clob              -- ��������������� ������������� ���������� (BASE64(<orders><name>���</name><direction>ASC/DESC</direction></orders>...))
  ) return                  TORDERS              -- ��������� ������
  is
    RORDERS                 TORDERS;             -- ����� ��� ���������� ������
    XDOC                    PKG_XPATH.TDOCUMENT; -- �������� XML
    XROOT                   PKG_XPATH.TNODE;     -- ������ ��������� XML
    XNODE                   PKG_XPATH.TNODE;     -- ����� ���� ���������
    XNODES                  PKG_XPATH.TNODES;    -- ����� ��������� ����� ���������
  begin
    /* �������������� �������� ��������� */
    RORDERS := TORDERS();
    /* ��������� XML */
    XDOC := PKG_XPATH.PARSE_FROM_CLOB(LCXML => '<' || SRQ_TAG_XROOT || '>' ||
                                               BLOB2CLOB(LBDATA   => BASE64_DECODE(LCSRCE => CORDERS),
                                                         SCHARSET => PKG_CHARSET.CHARSET_UTF_()) || '</' ||
                                               SRQ_TAG_XROOT || '>');
    /* ��������� �������� ���� */
    XROOT := PKG_XPATH.ROOT_NODE(RDOCUMENT => XDOC);
    /* ���������� ������ ������� */
    XNODES := PKG_XPATH.LIST_NODES(RPARENT_NODE => XROOT, SPATTERN => '/' || SRQ_TAG_XROOT || '/' || SRQ_TAG_XORDERS);
    /* ���� �� ������ �������� */
    for I in 1 .. PKG_XPATH.COUNT_NODES(RNODES => XNODES)
    loop
      /* ������� ������� �� ��� ������ */
      XNODE := PKG_XPATH.ITEM_NODE(RNODES => XNODES, INUMBER => I);
      /* ������� ��� � ��������� */
      RORDERS.EXTEND();
      RORDERS(RORDERS.LAST) := TORDER_MAKE(SNAME      => PKG_XPATH.VALUE(RNODE => XNODE, SPATTERN => SRQ_TAG_SNAME),
                                           SDIRECTION => PKG_XPATH.VALUE(RNODE => XNODE, SPATTERN => SRQ_TAG_SDIRECTION));
    end loop;
    /* ��������� �������� */
    PKG_XPATH.FREE(RDOCUMENT => XDOC);
    /* ����� ��������� */
    return RORDERS;
  exception
    when others then
      /* ��������� �������� */
      PKG_XPATH.FREE(RDOCUMENT => XDOC);
      /* ������ ������ */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end TORDERS_FROM_XML;
  
  /* ���������� ���������� ���������� � ������� */
  procedure TORDERS_SET_QUERY
  (
    RDATA_GRID              in TDATA_GRID,      -- �������� �������
    RORDERS                 in TORDERS,         -- ��������� ����������
    SPATTERN                in varchar2,        -- ������ ��� ����������� ������� ������ � ������    
    CSQL                    in out nocopy clob  -- ����� �������
  )
  is
    CSQL_ORDERS             clob;               -- ����� ��� ������� ���������� � �������
  begin
    /* ���� ���������� ������ */
    if ((RORDERS is not null) and (RORDERS.COUNT > 0)) then
      CSQL_ORDERS := ' order by ';
      for I in RORDERS.FIRST .. RORDERS.LAST
      loop
        /* ����� ����������� � ������ - ������������ ��������, ����� �������� SQL-�������� */
        if ((TCOL_DEFS_FIND(RCOL_DEFS => RDATA_GRID.RCOL_DEFS, SNAME => RORDERS(I).SNAME).SNAME is not null) and
           (RORDERS(I).SDIRECTION in (SORDER_DIRECTION_ASC, SORDER_DIRECTION_DESC))) then
          CSQL_ORDERS := CSQL_ORDERS || RORDERS(I).SNAME || ' ' || RORDERS(I).SDIRECTION;
          if (I < RORDERS.LAST) then
            CSQL_ORDERS := CSQL_ORDERS || ', ';
          end if;
        end if;
      end loop;
    end if;
    CSQL := replace(CSQL, SPATTERN, CSQL_ORDERS);
  end TORDERS_SET_QUERY;
  
end PKG_P8PANELS_VISUAL;
/

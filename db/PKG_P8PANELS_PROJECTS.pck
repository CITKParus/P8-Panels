create or replace package PKG_P8PANELS_PROJECTS as

  /* ���� ������ - ������ ����� ������� */
  type TSTAGE_ART is record
  (
    NRN                     FPDARTCL.RN%type,   -- ���. ����� ������
    SCODE                   FPDARTCL.CODE%type, -- ��� ������
    SNAME                   FPDARTCL.NAME%type, -- ������������ ������
    NPLAN                   PKG_STD.TNUMBER,    -- �������� �������� �� ������
    NCOST_FACT              PKG_STD.TNUMBER,    -- ����������� ������� (null - �� �������� �������� ������)
    NCOST_DIFF              PKG_STD.TNUMBER,    -- ���������� �� �������� (null - �� �������� �������� ������)
    NCTRL_COST              PKG_STD.TNUMBER,    -- �������� ������ (null - �� �������� �������� ������, 0 - ��� ����������, 1 - ���� ����������)
    NCONTR                  PKG_STD.TNUMBER,    -- ��������������� (null - �� �������� �������� ������������)
    NCONTR_LEFT             PKG_STD.TNUMBER,    -- ������� � ������������ (null - �� �������� �������� ������������)
    NCTRL_CONTR             PKG_STD.TNUMBER     -- �������� ������������ (null - �� �������� �������� ������������, 0 - ��� ����������, 1 - ���� ����������)
  );
  
  /* ���� ������ - ��������� ������ ����� ������� */
  type TSTAGE_ARTS is table of TSTAGE_ART; 

  /* ����� �������� */
  procedure COND;

  /* ��������� ���. ������ ��������� ��������� (��������) ������� */
  function GET_DOC_OSN_LNK_DOCUMENT
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ���. ����� ��������� ��������� (��������)

  /* ������ �������� �������������� ������� */
  procedure SELECT_FIN
  (
    NRN                     in number, -- ���. ����� �������
    NDIRECTION              in number, -- ����������� (0 - ������, 1 - ������)
    NIDENT                  out number -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  );
  
  /* ��������� ����� ��������� �������������� ������� */
  function GET_FIN_IN
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ����� ��������� �������������� �������

  /* ��������� ����� ���������� �������������� ������� */
  function GET_FIN_OUT
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ����� ���������� �������������� �������

  /* ��������� ��������� �������������� ������� */
  function GET_CTRL_FIN
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)

  /* ��������� ��������� ������������ ������� */
  function GET_CTRL_CONTR
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)

  /* ��������� ��������� ������������ ������� */
  function GET_CTRL_COEXEC
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)

  /* ��������� ��������� ������ ������� */
  function GET_CTRL_PERIOD
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ��������� ������ ������� */
  function GET_CTRL_COST
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ��������� ����������� ������� */
  function GET_CTRL_ACT
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)

  /* ������ �������� */
  procedure LIST
  (
    NPAGE_NUMBER            in number,  -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,    -- �������
    CORDERS                 in clob,    -- ����������
    NINCLUDE_DEF            in number,  -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob    -- ��������������� ������� ������
  );
  
  /* ����� ������ �������� */
  procedure STAGES_COND;
  
  
  /* ������ �������� �������������� ����� ������� */
  procedure STAGES_SELECT_FIN
  (
    NPRN                    in number := null, -- ���. ����� ������� (null - �� �������� �� �������)
    NRN                     in number := null, -- ���. ����� ����� ������� (null - �� �������� �� �����)
    NDIRECTION              in number,         -- ����������� (0 - ������, 1 - ������)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  );
  
  /* ��������� ����� ��������� �������������� ����� ������� */
  function STAGES_GET_FIN_IN
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ����� ��������� �������������� �������

  /* ��������� ����� ���������� �������������� ����� ������� */
  function STAGES_GET_FIN_OUT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ����� ���������� �������������� �������

  /* ��������� ��������� �������������� ����� ������� */
  function STAGES_GET_CTRL_FIN
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (0 - ��� ����������, 1 - ���� ����������)

  /* ��������� ��������� ������������ ����� ������� */
  function STAGES_GET_CTRL_CONTR
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)

  /* ��������� ��������� ������������ ����� ������� */
  function STAGES_GET_CTRL_COEXEC
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ��������� ������ ����� ������� */
  function STAGES_GET_CTRL_PERIOD
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ��������� ������ ����� ������� */
  function STAGES_GET_CTRL_COST
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ��������� ����������� ����� ������� */
  function STAGES_GET_CTRL_ACT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ��������� (0 - ��� ����������, 1 - ���� ����������)
  
  /* ��������� ������� ����� ���������� ����� ������� */
  function STAGES_GET_DAYS_LEFT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ���������� ���� (null - �� ����������)
  
  /* ������ ������� ������� ������ ����� ������� */
  procedure STAGES_SELECT_COST_FACT
  (
    NRN                     in number,  -- ���. ����� ����� ������� (null - �� �������� �� �����)
    NIDENT                  out number  -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  );
  
  /* ��������� ����� ����������� ������ ����� ������� */
  function STAGES_GET_COST_FACT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number;     -- ����� ����������� ������

  /* ��������� ����� ���������� ����� ������� */
  function STAGES_GET_SUMM_REALIZ
  (
    NRN                     in number,  -- ���. ����� ����� �������
    NFPDARTCL_REALIZ        in number   -- ���. ����� ������ ����������� ��� ����������
  ) return                  number;     -- ����� ����������
  
  /* ������ ������ */
  procedure STAGES_LIST
  (
    NPRN                    in number,  -- ���. ����� �������
    NPAGE_NUMBER            in number,  -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,    -- �������
    CORDERS                 in clob,    -- ����������
    NINCLUDE_DEF            in number,  -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob    -- ��������������� ������� ������
  );
  
  /* ������������ ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC;
  
  /* ������ ������� ������� ������ �� ������ ����������� ����� ������� */
  procedure STAGE_ARTS_SELECT_COST_FACT
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ������ (null - �� ����)
    NFINFLOW_TYPE           in number := null, -- ��� �������� �� ������ (null - �� ����, 0 - �������, 1 - ������, 2 - ������)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  );
  
  /* ��������� �����-���� �� ������ ����������� ����� ������� */
  function STAGE_ARTS_GET_COST_FACT
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ����������� (null - �� ����)
    NFINFLOW_TYPE           in number := null  -- ��� �������� �� ������ (null - �� ����, 0 - �������, 1 - ������, 2 - ������)
  ) return                  number;            -- �����-���� �� ������
  
  /* ������ ������� ��������� � ��������������� �� ������ ����������� ����� ������� */
  procedure STAGE_ARTS_SELECT_CONTR
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ������ (null - �� ����)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  );
  
  /* ��������� ������ ������ ����� ������� */
  procedure STAGE_ARTS_GET
  (
    NSTAGE                  in number,      -- ���. ����� ����� �������  
    NINC_COST               in number := 0, -- �������� �������� � �������� (0 - ���, 1 - ��)
    NINC_CONTR              in number := 0, -- �������� �������� � ������������ (0 - ���, 1 - ��)
    RSTAGE_ARTS             out TSTAGE_ARTS -- ������ ������ ����� �������
  );
  
  /* ������ ������ ����������� ����� ������� */
  procedure STAGE_ARTS_LIST
  (
    NSTAGE                  in number,  -- ���. ����� ����� �������
    CFILTERS                in clob,    -- �������
    NINCLUDE_DEF            in number,  -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob    -- ��������������� ������� ������
  );

  /* ������ ��������� ����� ������� */
  procedure STAGE_CONTRACTS_COND;

  /* ������ ��������� ����� ������� */
  procedure STAGE_CONTRACTS_LIST
  (
    NSTAGE                  in number,  -- ���. ����� ����� �������
    NPAGE_NUMBER            in number,  -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,    -- �������
    CORDERS                 in clob,    -- ����������
    NINCLUDE_DEF            in number,  -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob    -- ��������������� ������� ������
  );

end PKG_P8PANELS_PROJECTS;
/
create or replace package body PKG_P8PANELS_PROJECTS as

/*
TODO: owner="root" created="20.09.2023"
text="����� �������!!!!"
*/
  /* ��������� - ��������������� �������� */
  SYES                        constant PKG_STD.TSTRING := '��';              -- ��
  NDAYS_LEFT_LIMIT            constant PKG_STD.TNUMBER := 30;                -- ����� �������� ���� ��� �������� ������
  SFPDARTCL_REALIZ            constant PKG_STD.TSTRING := '14 ���� ��� ���'; -- �������� ������ ����������� ��� ����� ����������

  /* ��������� - ����� ��������� ������� "PM0010" - "����������� ����� �������" */
  SSTAGES_CT_CALC_SH_CACL     constant PKG_STD.TSTRING := '�����������'; -- ���� "�����������"

  /* ��������� - ������� ��������� ������� "PM0010" - "����������� ����� �������" */
  SSTAGES_CT_CALC_TBL_CLARTS  constant PKG_STD.TSTRING := '�����������������'; -- ������� "������ �����������"

  /* ��������� - ������ ��������� ������� "PM0010" - "����������� ����� �������" */
  SSTAGES_CT_CALC_LN_ARTS     constant PKG_STD.TSTRING := '������'; -- ������ "������"

  /* ��������� - ������� ��������� ������� "PM0010" - "����������� ����� �������" */
  SSTAGES_CT_CALC_CL_NUMB     constant PKG_STD.TSTRING := '�����';         -- ������� "�����"
  SSTAGES_CT_CALC_CL_NAME     constant PKG_STD.TSTRING := '������������';  -- ������� "������������ ������"
  SSTAGES_CT_CALC_CL_SUMM_PL  constant PKG_STD.TSTRING := '�������������'; -- ������� "�������� �����"

  /* ��������� - ��������� ��������� ������� "PM0010" - "����������� ����� �������" */
  SSTAGES_CT_CALC_PRM_COMP    constant PKG_STD.TSTRING := 'PM0010_�����������';       -- �������� "�����������"
  SSTAGES_CT_CALC_PRM_PRJ     constant PKG_STD.TSTRING := 'PM0010_����������';        -- �������� "��� �������"
  SSTAGES_CT_CALC_PRM_STG     constant PKG_STD.TSTRING := 'PM0010_�����������������'; -- �������� "����� ����� �������"
  SSTAGES_CT_CALC_PRM_ARTSCAT constant PKG_STD.TSTRING := 'PM0010_������������';      -- �������� "������� ������ �����������"
  
  /* ���������� ������ ������� */
  function GET
  (
    NRN                     in number        -- ���. ����� �������
  ) return                  PROJECT%rowtype  -- ������ �������
  is
    RRES                    PROJECT%rowtype; -- ����� ��� ����������
  begin
    select P.* into RRES from PROJECT P where P.RN = NRN;
    return RRES;
  exception
    when NO_DATA_FOUND then
      PKG_MSG.RECORD_NOT_FOUND(NFLAG_SMART => 0, NDOCUMENT => NRN, SUNIT_TABLE => 'PROJECT');
  end GET;

  /* ����� �������� */
  procedure COND
  as
  begin
    /* ��������� ������� ������� */
    PKG_COND_BROKER.SET_TABLE(STABLE_NAME => 'PROJECT');
    /* ��� ������� */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME    => 'CODE',
                                       SCONDITION_NAME => 'EDPROJECTTYPE',
                                       SJOINS          => 'PRJTYPE <- RN;PRJTYPE');
    /* �������� */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME => 'CODE', SCONDITION_NAME => 'EDMNEMO');
    /* ������������ */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME => 'NAME', SCONDITION_NAME => 'EDNAME');
    /* ��������� ������������ */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME => 'NAME_USL', SCONDITION_NAME => 'EDNAME_USL');
    /* ���� ������ ���� */
    PKG_COND_BROKER.ADD_CONDITION_BETWEEN(SCOLUMN_NAME         => 'BEGPLAN',
                                          SCONDITION_NAME_FROM => 'EDPLANBEGFrom',
                                          SCONDITION_NAME_TO   => 'EDPLANBEGTo');
    /* ���� ��������� ���� */
    PKG_COND_BROKER.ADD_CONDITION_BETWEEN(SCOLUMN_NAME         => 'ENDPLAN',
                                          SCONDITION_NAME_FROM => 'EDPLANENDFrom',
                                          SCONDITION_NAME_TO   => 'EDPLANENDTo');
    /* ��������� */
    PKG_COND_BROKER.ADD_CONDITION_ENUM(SCOLUMN_NAME => 'STATE', SCONDITION_NAME => 'CGSTATE');
    /* �������� */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME    => 'AGNABBR',
                                       SCONDITION_NAME => 'EDEXT_CUST',
                                       SJOINS          => 'EXT_CUST <- RN;AGNLIST');
    /* �������� �������������� */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_FIN') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_FIN(RN) = :EDCTRL_FIN');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_FIN',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_FIN'));
    end if;  
    /* �������� ������������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_CONTR') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_CONTR(RN) = :EDCTRL_CONTR');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_CONTR',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_CONTR'));
    end if;
    /* �������� ������������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_COEXEC') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_COEXEC(RN) = :EDCTRL_COEXEC');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_COEXEC',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_COEXEC'));
    end if;
    /* �������� ������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_PERIOD') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_PERIOD(RN) = :EDCTRL_PERIOD');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_PERIOD',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_PERIOD'));
    end if;
    /* �������� ������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_COST') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_COST(RN) = :EDCTRL_COST');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_COST',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_COST'));
    end if;
    /* �������� ����������� */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_ACT') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.GET_CTRL_ACT(RN) = :EDCTRL_ACT');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_ACT',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_ACT'));
    end if;
  end COND;
  
  /* ��������� ���. ������ ��������� ��������� (��������) ������� */
  function GET_DOC_OSN_LNK_DOCUMENT
  (
    NRN                     in number   -- ���. ����� �������
  ) return                  number      -- ���. ����� ��������� ��������� (��������)
  is
  begin
    /* ������� ������� � ���������� �� �� ����� ������� */
    for C in (select CN.RN
                from PROJECTSTAGE PS,
                     STAGES       S,
                     CONTRACTS    CN
               where PS.PRN = NRN
                 and PS.FACEACCCUST = S.FACEACC
                 and S.PRN = CN.RN
               group by CN.RN)
    loop
      /* ����� ������ ��������� */
      return C.RN;
    end loop;
    /* ������ �� ����� */
    return null;
  end GET_DOC_OSN_LNK_DOCUMENT;

  /* ������ �������� �������������� ������� */
  procedure SELECT_FIN
  (
    NRN                     in number, -- ���. ����� �������
    NDIRECTION              in number, -- ����������� (0 - ������, 1 - ������)
    NIDENT                  out number -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  )
  is
  begin
    /* ������� ������� */
    STAGES_SELECT_FIN(NPRN => NRN, NDIRECTION => NDIRECTION, NIDENT => NIDENT);
  end SELECT_FIN;

  /* ��������� ����� ��������� �������������� ������� */
  function GET_FIN_IN
  (
    NRN                     in number             -- ���. ����� �������
  ) return                  number                -- ����� ��������� �������������� �������
  is
    NRES                    PKG_STD.TNUMBER := 0; -- ����� ��� ����������
  begin
    /* ������� ����� � ������� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      NRES := NRES + STAGES_GET_FIN_IN(NRN => C.RN);
    end loop;
    /* ���������� ��������� */
    return NRES;
  end GET_FIN_IN;

  /* ��������� ����� ���������� �������������� ������� */
  function GET_FIN_OUT
  (
    NRN                     in number             -- ���. ����� �������
  ) return                  number                -- ����� ���������� �������������� �������
  is
    NRES                    PKG_STD.TNUMBER := 0; -- ����� ��� ����������
  begin
    /* ������� ����� � ������� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      NRES := NRES + STAGES_GET_FIN_OUT(NRN => C.RN);
    end loop;
    /* ���������� ��������� */
    return NRES;
  end GET_FIN_OUT;

  /* ��������� ��������� �������������� ������� */
  function GET_CTRL_FIN
  (
    NRN                     in number         -- ���. ����� �������
  ) return                  number            -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    BFOUND                  boolean := false; -- ���� ������� ������
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ���� ������� ������ */
      BFOUND := true;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (STAGES_GET_CTRL_FIN(NRN => C.RN) = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ����� - ���������� ��� */
    if (BFOUND) then
      return 0;
    else
      return null;
    end if;
  end GET_CTRL_FIN;

  /* ��������� ��������� ������������ ������� */
  function GET_CTRL_CONTR
  (
    NRN                     in number            -- ���. ����� �������
  ) return                  number               -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    NSTAGE_CTRL             PKG_STD.TNUMBER;     -- ��������� �����
    NCNT_STAGES             PKG_STD.TNUMBER :=0; -- ���������� ������
    NCNT_NULL               PKG_STD.TNUMBER :=0; -- ���������� "��������������" ������
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ������� ������ */
      NCNT_STAGES := NCNT_STAGES + 1;
      /* ������� ��������� ����� */
      NSTAGE_CTRL := STAGES_GET_CTRL_CONTR(NRN => C.RN);
      /* ���������� ���������� "��������������" */
      if (NSTAGE_CTRL is null) then
        NCNT_NULL := NCNT_NULL + 1;
      end if;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (NSTAGE_CTRL = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ���� ���� �� �������� �������� - �� � ��������� ������� ���� */
    if (NCNT_NULL = NCNT_STAGES) then
      return null;
    end if;
    /* ���� �� ����� - ���������� ��� */
    if (NCNT_STAGES > 0) then
      return 0;
    else
      /* ��� ������ � ��� �������� */
      return null;
    end if;
  end GET_CTRL_CONTR;

  /* ��������� ��������� ������������ ������� */
  function GET_CTRL_COEXEC
  (
    NRN                     in number         -- ���. ����� �������
  ) return                  number            -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    BFOUND                  boolean := false; -- ���� ������� ������  
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ���� ������� ������ */
      BFOUND := true;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (STAGES_GET_CTRL_COEXEC(NRN => C.RN) = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ����� - ���������� ��� */
    if (BFOUND) then
      return 0;
    else
      return null;
    end if;
  end GET_CTRL_COEXEC;

  /* ��������� ��������� ������ ������� */
  function GET_CTRL_PERIOD
  (
    NRN                     in number            -- ���. ����� �������
  ) return                  number               -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    NSTAGE_CTRL             PKG_STD.TNUMBER;     -- ��������� �����
    NCNT_STAGES             PKG_STD.TNUMBER :=0; -- ���������� ������
    NCNT_NULL               PKG_STD.TNUMBER :=0; -- ���������� "��������������" ������
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ������� ������ */
      NCNT_STAGES := NCNT_STAGES + 1;
      /* ������� ��������� ����� */
      NSTAGE_CTRL := STAGES_GET_CTRL_PERIOD(NRN => C.RN);
      /* ���������� ���������� "��������������" */
      if (NSTAGE_CTRL is null) then
        NCNT_NULL := NCNT_NULL + 1;
      end if;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (NSTAGE_CTRL = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ���� ���� �� �������� �������� - �� � ��������� ������� ���� */
    if (NCNT_NULL = NCNT_STAGES) then
      return null;
    end if;
    /* ���� �� ����� - ���������� ��� */
    if (NCNT_STAGES > 0) then
      return 0;
    else
      /* ��� ������ � ��� �������� */
      return null;
    end if;
  end GET_CTRL_PERIOD;
  
  /* ��������� ��������� ������ ������� */
  function GET_CTRL_COST
  (
    NRN                     in number            -- ���. ����� �������
  ) return                  number               -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    NSTAGE_CTRL             PKG_STD.TNUMBER;     -- ��������� �����
    NCNT_STAGES             PKG_STD.TNUMBER :=0; -- ���������� ������
    NCNT_NULL               PKG_STD.TNUMBER :=0; -- ���������� "��������������" ������
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ������� ������ */
      NCNT_STAGES := NCNT_STAGES + 1;
      /* ������� ��������� ����� */
      NSTAGE_CTRL := STAGES_GET_CTRL_COST(NRN => C.RN);
      /* ���������� ���������� "��������������" */
      if (NSTAGE_CTRL is null) then
        NCNT_NULL := NCNT_NULL + 1;
      end if;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (NSTAGE_CTRL = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ���� ���� �� �������� �������� - �� � ��������� ������� ���� */
    if (NCNT_NULL = NCNT_STAGES) then
      return null;
    end if;
    /* ���� �� ����� - ���������� ��� */
    if (NCNT_STAGES > 0) then
      return 0;
    else
      /* ��� ������ � ��� �������� */
      return null;
    end if;
  end GET_CTRL_COST;
  
  /* ��������� ��������� ����������� ������� */
  function GET_CTRL_ACT
  (
    NRN                     in number         -- ���. ����� �������
  ) return                  number            -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    BFOUND                  boolean := false; -- ���� ������� ������  
  begin
    /* ������� ����� */
    for C in (select PS.RN from PROJECTSTAGE PS where PS.PRN = NRN)
    loop
      /* �������� ���� ������� ������ */
      BFOUND := true;
      /* ���� � ����� ���� ���������� - ��� ���� � � ������� */
      if (STAGES_GET_CTRL_ACT(NRN => C.RN) = 1) then
        return 1;
      end if;
    end loop;
    /* ���� �� ����� - ���������� ��� */
    if (BFOUND) then
      return 0;
    else
      return null;
    end if;
  end GET_CTRL_ACT;
  
  /* ������ �������� */
  procedure LIST
  (
    NPAGE_NUMBER            in number,                             -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,                               -- �������
    CORDERS                 in clob,                               -- ����������
    NINCLUDE_DEF            in number,                             -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob                               -- ��������������� ������� ������
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- ����������� ������
    NIDENT                  PKG_STD.TREF := GEN_IDENT();           -- ������������� ������
    RF                      PKG_P8PANELS_VISUAL.TFILTERS;          -- �������
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- ����������
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- �������� �������
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- ������ �������
    RCOL_VALS               PKG_P8PANELS_VISUAL.TCOL_VALS;         -- ��������������� �������� ��������
    NROW_FROM               PKG_STD.TREF;                          -- ����� ������ �
    NROW_TO                 PKG_STD.TREF;                          -- ����� ������ ��
    CSQL                    clob;                                  -- ����� ��� �������
    ICURSOR                 integer;                               -- ������ ��� ���������� �������
    NECON_RESP_DP           PKG_STD.TREF;                          -- ���. ����� �� "������������� ���������"
  begin
    /* ������ ������� */
    RF := PKG_P8PANELS_VISUAL.TFILTERS_FROM_XML(CFILTERS => CFILTERS);
    /* ����� ���������� */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* ����������� ����� � ������ �������� � ����� ����� � � �� */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* �������������� ������� ������ */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* ��������� � ������� �������� ������� */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => '���. �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCODE',
                                               SCAPTION   => '���',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDMNEMO',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME',
                                               SCAPTION   => '������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDNAME',
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME_USL',
                                               SCAPTION   => '�������� ������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDNAME_USL',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEXPECTED_RES',
                                               SCAPTION   => '��������� ����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPRJTYPE',
                                               SCAPTION   => '���',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDPROJECTTYPE',
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEXT_CUST',
                                               SCAPTION   => '��������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDEXT_CUST',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SGOVCNTRID',
                                               SCAPTION   => '���',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_OSN',
                                               SCAPTION   => '��������-���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_SDOC_OSN',
                                               SCAPTION   => '��������-��������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_SDOC_OSN',
                                               SCAPTION   => '��������-��������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSUBDIV_RESP',
                                               SCAPTION   => '�������������-�����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SRESPONSIBLE',
                                               SCAPTION   => '������������� �����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SECON_RESP',
                                               SCAPTION   => '������������� ���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 0, BCLEAR => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 2);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 3);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 4);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 5);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSTATE',
                                               SCAPTION   => '���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'CGSTATE',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DBEGPLAN',
                                               SCAPTION   => '���� ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDPLANBEGFrom',
                                               SCOND_TO   => 'EDPLANBEGTo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DENDPLAN',
                                               SCAPTION   => '���� ���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDPLANENDFrom',
                                               SCOND_TO   => 'EDPLANENDTo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCOST_SUM',
                                               SCAPTION   => '���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCURNAMES',
                                               SCAPTION   => '������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NFIN_IN',
                                               SCAPTION   => '�������� ��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_NFIN_IN',
                                               SCAPTION   => '�������� �������������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_NFIN_IN',
                                               SCAPTION   => '�������� �������������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NFIN_OUT',
                                               SCAPTION   => '��������� ��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_NFIN_OUT',
                                               SCAPTION   => '��������� �������������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_NFIN_OUT',
                                               SCAPTION   => '��������� �������������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 0, BCLEAR => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_FIN',
                                               SCAPTION   => '��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_FIN',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_CONTR',
                                               SCAPTION   => '������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_CONTR',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_COEXEC',
                                               SCAPTION   => '�������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_COEXEC',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_PERIOD',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_PERIOD',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_COST',
                                               SCAPTION   => '�������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_COST',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_ACT',
                                               SCAPTION   => '�����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_ACT',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    /* ��������� �������������� �������� - ������������� ��������� */
    FIND_DOCS_PROPS_CODE(NFLAG_SMART => 1, NCOMPANY => NCOMPANY, SCODE => '���.SECON_RESP', NRN => NECON_RESP_DP);
    /* ������� ������ */
    begin
      /* �������� ������ */
      CSQL := 'select *
            from (select D.*,
                         ROWNUM NROW
                    from (select P.RN NRN,
                                 P.CODE SCODE,
                                 P.NAME SNAME,
                                 P.NAME_USL SNAME_USL,
                                 P.EXPECTED_RES SEXPECTED_RES,
                                 PT.CODE SPRJTYPE,
                                 EC.AGNABBR SEXT_CUST,
                                 ''"'' || GC.CODE || ''"'' SGOVCNTRID,
                                 P.DOC_OSN SDOC_OSN,
                                 ''Contracts'' SLNK_UNIT_SDOC_OSN,
                                 PKG_P8PANELS_PROJECTS.GET_DOC_OSN_LNK_DOCUMENT(P.RN) NLNK_DOCUMENT_SDOC_OSN,
                                 SR.CODE SSUBDIV_RESP,
                                 R.AGNABBR SRESPONSIBLE,
                                 F_DOCS_PROPS_GET_STR_VALUE(:NECON_RESP_DP, ''Projects'', P.RN) SECON_RESP,
                                 P.STATE NSTATE,
                                 P.BEGPLAN DBEGPLAN,
                                 P.ENDPLAN DENDPLAN,
                                 P.COST_SUM_BASECURR NCOST_SUM,
                                 CN.INTCODE SCURNAMES,
                                 PKG_P8PANELS_PROJECTS.GET_FIN_IN(P.RN) NFIN_IN,
                                 ''Paynotes'' SLNK_UNIT_NFIN_IN,
                                 0 NLNK_DOCUMENT_NFIN_IN,                                 
                                 PKG_P8PANELS_PROJECTS.GET_FIN_OUT(P.RN) NFIN_OUT,
                                 ''Paynotes'' SLNK_UNIT_NFIN_OUT,
                                 1 NLNK_DOCUMENT_NFIN_OUT,                                 
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_FIN(P.RN) NCTRL_FIN,
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_CONTR(P.RN) NCTRL_CONTR,
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_COEXEC(P.RN) NCTRL_COEXEC,
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_PERIOD(P.RN) NCTRL_PERIOD,
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_COST(P.RN) NCTRL_COST,
                                 PKG_P8PANELS_PROJECTS.GET_CTRL_ACT(P.RN) NCTRL_ACT
                            from PROJECT        P,
                                 PRJTYPE        PT,
                                 AGNLIST        EC,
                                 GOVCNTRID      GC,
                                 INS_DEPARTMENT SR,
                                 AGNLIST        R,
                                 CURNAMES       CN
                           where P.PRJTYPE = PT.RN
                             and P.EXT_CUST = EC.RN(+)
                             and P.GOVCNTRID = GC.RN(+)
                             and P.SUBDIV_RESP = SR.RN(+)
                             and P.RESPONSIBLE = R.RN(+)
                             and P.CURNAMES = CN.RN 
                             and P.RN in (select ID from COND_BROKER_IDSMART where IDENT = :NIDENT) %ORDER_BY%) D) F
           where F.NROW between :NROW_FROM and :NROW_TO';
      /* ���� ���������� */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* ���� ������� */
      PKG_P8PANELS_VISUAL.TFILTERS_SET_QUERY(NIDENT     => NIDENT,
                                             NCOMPANY   => NCOMPANY,
                                             SUNIT      => 'Projects',
                                             SPROCEDURE => 'PKG_P8PANELS_PROJECTS.COND',
                                             RDATA_GRID => RDG,
                                             RFILTERS   => RF);
      /* ��������� ��� */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* ������ ����������� ���������� */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NECON_RESP_DP', NVALUE => NECON_RESP_DP);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NIDENT', NVALUE => NIDENT);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      /* ��������� ��������� ������ ������� */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 10);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 11);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 12);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 13);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 14);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 15);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 16);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 17);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 18);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 19);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 20);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 21);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 22);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 23);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 24);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 25);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 26);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 27);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 28);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 29);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 30);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 31);
      /* ������ ������� */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* ������� ��������� ������ */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* ��������� ������� � ������� */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NRN', ICURSOR => ICURSOR, NPOSITION => 1, BCLEAR => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SCODE', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SNAME', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SNAME_USL',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SEXPECTED_RES',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SPRJTYPE', ICURSOR => ICURSOR, NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SEXT_CUST',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SGOVCNTRID',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SDOC_OSN', ICURSOR => ICURSOR, NPOSITION => 9);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_SDOC_OSN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 10);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_SDOC_OSN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 11);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SSUBDIV_RESP',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 12);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SRESPONSIBLE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 13);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SECON_RESP',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 14);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NSTATE', ICURSOR => ICURSOR, NPOSITION => 15);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DBEGPLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 16);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DENDPLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 17);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCOST_SUM',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 18);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SCURNAMES',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 19);      
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NFIN_IN', ICURSOR => ICURSOR, NPOSITION => 20);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_NFIN_IN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 21);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_NFIN_IN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 22);      
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 23);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 24);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 25);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_FIN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 26);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_CONTR',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 27);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_COEXEC',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 28);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_PERIOD',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 29);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_COST',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 30);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_ACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 31);
        /* ��������� ������ � ������� */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
      /* ����������� ������ */
      PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* ����������� �������� */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end LIST;
  
  /* ���������� ������ ����� ������� */
  function STAGES_GET
  (
    NRN                     in number             -- ���. ����� ����� �������
  ) return                  PROJECTSTAGE%rowtype  -- ������ ����� �������
  is
    RRES                    PROJECTSTAGE%rowtype; -- ����� ��� ����������
  begin
    select PS.* into RRES from PROJECTSTAGE PS where PS.RN = NRN;
    return RRES;
  exception
    when NO_DATA_FOUND then
      PKG_MSG.RECORD_NOT_FOUND(NFLAG_SMART => 0, NDOCUMENT => NRN, SUNIT_TABLE => 'PROJECTSTAGE');
  end STAGES_GET;
  
  /* ����� ������ �������� */
  procedure STAGES_COND
  as
  begin
    /* ��������� ������� ������� */
    PKG_COND_BROKER.SET_TABLE(STABLE_NAME => 'PROJECTSTAGE');
    /* ������ */
    PKG_COND_BROKER.SET_COLUMN_PRN(SCOLUMN_NAME => 'PRN');
    /* ����� */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME => 'NUMB', SCONDITION_NAME => 'EDNUMB');
    /* ������������ */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME => 'NAME', SCONDITION_NAME => 'EDNAME');
    /* ���� ������ ���� */
    PKG_COND_BROKER.ADD_CONDITION_BETWEEN(SCOLUMN_NAME         => 'BEGPLAN',
                                          SCONDITION_NAME_FROM => 'EDPLANBEGFrom',
                                          SCONDITION_NAME_TO   => 'EDPLANBEGTo');
    /* ���� ��������� ���� */
    PKG_COND_BROKER.ADD_CONDITION_BETWEEN(SCOLUMN_NAME         => 'ENDPLAN',
                                          SCONDITION_NAME_FROM => 'EDPLANENDFrom',
                                          SCONDITION_NAME_TO   => 'EDPLANENDTo');
    /* ��������� */
    PKG_COND_BROKER.ADD_CONDITION_ENUM(SCOLUMN_NAME => 'STATE', SCONDITION_NAME => 'CGSTATE');
    /* �������� �������������� */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_FIN') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_FIN(RN) = :EDCTRL_FIN');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_FIN',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_FIN'));
    end if;  
    /* �������� ������������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_CONTR') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_CONTR(RN) = :EDCTRL_CONTR');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_CONTR',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_CONTR'));
    end if;
    /* �������� ������������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_COEXEC') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_COEXEC(RN) = :EDCTRL_COEXEC');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_COEXEC',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_COEXEC'));
    end if;
    /* �������� ������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_PERIOD') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_PERIOD(RN) = :EDCTRL_PERIOD');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_PERIOD',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_PERIOD'));
    end if;
    /* �������� ������ */
    if (PKG_COND_BROKER.CONDITION_EXISTS(SCONDITION_NAME => 'EDCTRL_COST') = 1) then
      PKG_COND_BROKER.ADD_CLAUSE(SCLAUSE => 'PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_COST(RN) = :EDCTRL_COST');
      PKG_COND_BROKER.BIND_VARIABLE(SVARIABLE_NAME => 'EDCTRL_COST',
                                    NVALUE         => PKG_COND_BROKER.GET_CONDITION_NUM(SCONDITION_NAME => 'EDCTRL_COST'));
    end if;
  end STAGES_COND;
  
  /* ������ �������� �������������� ����� ������� */
  procedure STAGES_SELECT_FIN
  (
    NPRN                    in number := null, -- ���. ����� ������� (null - �� �������� �� �������)
    NRN                     in number := null, -- ���. ����� ����� ������� (null - �� �������� �� �����)
    NDIRECTION              in number,         -- ����������� (0 - ������, 1 - ������)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  )
  is
    NSELECTLIST             PKG_STD.TREF;      -- ���. ����� ����������� ������ ������ �����������
  begin
    /* ������� ������� */
    for C in (select PN.COMPANY,
                     PN.RN
                from PAYNOTES PN,
                     DICTOPER O
               where PN.COMPANY in (select PS.COMPANY
                                      from PROJECTSTAGE PS
                                     where ((NRN is null) or ((NRN is not null) and (PS.RN = NRN)))
                                       and ((NPRN is null) or ((NPRN is not null) and (PS.PRN = NPRN))))
                 and PN.SIGNPLAN = 0
                 and PN.FINOPER = O.RN
                 and O.TYPOPER_DIRECT = NDIRECTION
                 and exists (select PNC.RN
                        from PAYNOTESCLC  PNC,
                             PROJECTSTAGE PS
                       where PNC.PRN = PN.RN
                         and PNC.FACEACCOUNT = PS.FACEACC
                         and ((NRN is null) or ((NRN is not null) and (PS.RN = NRN)))
                         and ((NPRN is null) or ((NPRN is not null) and (PS.PRN = NPRN)))))
    loop
      /* ���������� ������������� ������ */
      if (NIDENT is null) then
        NIDENT := GEN_IDENT();
      end if;
      /* ������� ����������� � ������ ���������� ������� */
      P_SELECTLIST_BASE_INSERT(NIDENT       => NIDENT,
                               NCOMPANY     => C.COMPANY,
                               NDOCUMENT    => C.RN,
                               SUNITCODE    => 'PayNotes',
                               SACTIONCODE  => null,
                               NCRN         => null,
                               NDOCUMENT1   => null,
                               SUNITCODE1   => null,
                               SACTIONCODE1 => null,
                               NRN          => NSELECTLIST);
    end loop;
  end STAGES_SELECT_FIN;
  
  /* ��������� ����� �������������� ����� ������� */
  function STAGES_GET_FIN
  (
    NRN                     in number,       -- ���. ����� ����� �������
    NDIRECTION              in number        -- ����������� (0 - ������, 1 - ������)
  ) return                  number           -- ����� �������������� �������
  is
    NRES                    PKG_STD.TNUMBER; -- ����� ��� ����������
  begin
    /* ��������� ����������� ������� ������� ����������� �� �������� ����� ������ ����� */
    select COALESCE(sum(PN.PAY_SUM * (PN.CURR_RATE_BASE/PN.CURR_RATE)), 0)
      into NRES
      from PAYNOTES PN,
           DICTOPER O
     where PN.COMPANY in (select PS.COMPANY from PROJECTSTAGE PS where PS.RN = NRN)
       and PN.SIGNPLAN = 0
       and PN.FINOPER = O.RN
       and O.TYPOPER_DIRECT = NDIRECTION
       and exists (select PNC.RN
              from PAYNOTESCLC  PNC,
                   PROJECTSTAGE PS
             where PNC.PRN = PN.RN
               and PNC.FACEACCOUNT = PS.FACEACC
               and PS.RN = NRN);
    /* ���������� ��������� */
    return NRES;
  end STAGES_GET_FIN;
  
  /* ��������� ����� ��������� �������������� ����� ������� */
  function STAGES_GET_FIN_IN
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ����� ��������� �������������� �������
  is
  begin
    return STAGES_GET_FIN(NRN => NRN, NDIRECTION => 0);
  end STAGES_GET_FIN_IN;

  /* ��������� ����� ���������� �������������� ����� ������� */
  function STAGES_GET_FIN_OUT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ����� ���������� �������������� �������
  is
  begin
    return STAGES_GET_FIN(NRN => NRN, NDIRECTION => 1);
  end STAGES_GET_FIN_OUT;

  /* ��������� ��������� �������������� ����� ������� */
  function STAGES_GET_CTRL_FIN
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ��������� (0 - ��� ����������, 1 - ���� ����������)
  is
  begin
    return 0;
  end STAGES_GET_CTRL_FIN;

  /* ��������� ��������� ������������ ����� ������� */
  function STAGES_GET_CTRL_CONTR
  (
    NRN                     in number             -- ���. ����� ����� �������
  ) return                  number                -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    RSTAGE_ARTS             TSTAGE_ARTS;          -- �������� � ������������ �� ������� �����
    NCNT_NULL               PKG_STD.TNUMBER := 0; -- ���������� ������ � ������������� ����������
  begin
    /* ������� �������� � ������������ �� ������� */
    STAGE_ARTS_GET(NSTAGE => NRN, NINC_CONTR => 1, RSTAGE_ARTS => RSTAGE_ARTS);
    /* ���� �������� ���� - ����� ����������� */
    if ((RSTAGE_ARTS is not null) and (RSTAGE_ARTS.COUNT > 0)) then
      for I in RSTAGE_ARTS.FIRST .. RSTAGE_ARTS.LAST
      loop
        if (RSTAGE_ARTS(I).NCTRL_CONTR is null) then
          NCNT_NULL := NCNT_NULL + 1;
        end if;
        /* ���� ���� ���� ������ ����� ���������� */
        if (RSTAGE_ARTS(I).NCTRL_CONTR = 1) then
          /* �� � ���� ����� ���������� */
          return 1;
        end if;
      end loop;
      /* ���� �� ���� ������ �� �������� �������� - �� � ��������� ����� ���� */
      if (NCNT_NULL = RSTAGE_ARTS.COUNT) then
        return null;
      end if;
      /* ���� �� ����� - ���������� ��� */
      return 0;
    else
      /* ��� ������ �� ������� */
      return null;
    end if;
  end STAGES_GET_CTRL_CONTR;

  /* ��������� ��������� ������������ ����� ������� */
  function STAGES_GET_CTRL_COEXEC
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ��������� (0 - ��� ����������, 1 - ���� ����������)
  is
  begin
    return 0;
  end STAGES_GET_CTRL_COEXEC;
  
  /* ��������� ��������� ������ ����� ������� */
  function STAGES_GET_CTRL_PERIOD
  (
    NRN                     in number        -- ���. ����� ����� �������
  ) return                  number           -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    NDAYS_LEFT              PKG_STD.TNUMBER; -- ������� ���� �� ���������� �����
  begin
    /* ������� ���������� ���� �� ���������� */
    NDAYS_LEFT := STAGES_GET_DAYS_LEFT(NRN => NRN);
    /* ���� �� �� ����� ���������� ���� - �� �� ����� � �������������� */
    if (NDAYS_LEFT is null) then
      return null;
    end if;
    /* ���� �������� ������ ������������ ������ */
    if (NDAYS_LEFT < NDAYS_LEFT_LIMIT) then
      /* �� ��� ���������� �������� �������� */
      return 1;
    else
      /* ���������� ��� */
      return 0;
    end if;
  end STAGES_GET_CTRL_PERIOD;
  
  /* ��������� ��������� ������ ����� ������� */
  function STAGES_GET_CTRL_COST
  (
    NRN                     in number             -- ���. ����� ����� �������
  ) return                  number                -- ��������� (null - �� ����������, 0 - ��� ����������, 1 - ���� ����������)
  is
    RSTAGE_ARTS             TSTAGE_ARTS;          -- �������� � �������� �� ������� �����
    NCNT_NULL               PKG_STD.TNUMBER := 0; -- ���������� ������ � ������������� ����������
  begin
    /* ������� �������� � �������� �� ������� */
    STAGE_ARTS_GET(NSTAGE => NRN, NINC_COST => 1, RSTAGE_ARTS => RSTAGE_ARTS);
    /* ���� �������� ���� - ����� ����������� */
    if ((RSTAGE_ARTS is not null) and (RSTAGE_ARTS.COUNT > 0)) then
      for I in RSTAGE_ARTS.FIRST .. RSTAGE_ARTS.LAST
      loop
        if (RSTAGE_ARTS(I).NCTRL_COST is null) then
          NCNT_NULL := NCNT_NULL + 1;
        end if;
        /* ���� ���� ���� ������ ����� ���������� */
        if (RSTAGE_ARTS(I).NCTRL_COST = 1) then
          /* �� � ���� ����� ���������� */
          return 1;
        end if;
      end loop;
      /* ���� �� ���� ������ �� �������� �������� - �� � ��������� ����� ���� */
      if (NCNT_NULL = RSTAGE_ARTS.COUNT) then
        return null;
      end if;
      /* ���� �� ����� - ���������� ��� */
      return 0;
    else
      /* ��� ������ �� ������� */
      return null;
    end if;
  end STAGES_GET_CTRL_COST;
  
  /* ��������� ��������� ����������� ����� ������� */
  function STAGES_GET_CTRL_ACT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ��������� (0 - ��� ����������, 1 - ���� ����������)
  is
  begin
    return 1;
  end STAGES_GET_CTRL_ACT;  
  
  /* ��������� ������� ����� ���������� ����� ������� */
  function STAGES_GET_DAYS_LEFT
  (
    NRN                     in number             -- ���. ����� ����� �������
  ) return                  number                -- ���������� ���� (null - �� ����������)
  is
    RSTG                    PROJECTSTAGE%rowtype; -- ������ �����
  begin
    /* ������� ���� */
    RSTG := STAGES_GET(NRN => NRN);
    /* ����� ������� ���� */
    if (RSTG.ENDPLAN is not null) then
      return RSTG.ENDPLAN - sysdate;
    else
      return null;
    end if;
  end STAGES_GET_DAYS_LEFT;
  
  /* ������ ������� ������� ������ ����� ������� */
  procedure STAGES_SELECT_COST_FACT
  (
    NRN                     in number,  -- ���. ����� ����� ������� (null - �� �������� �� �����)
    NIDENT                  out number  -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  )
  is
  begin
    STAGE_ARTS_SELECT_COST_FACT(NSTAGE => NRN, NFINFLOW_TYPE => 2, NIDENT => NIDENT);
  end STAGES_SELECT_COST_FACT;
  
  /* ��������� ����� ����������� ������ ����� ������� */
  function STAGES_GET_COST_FACT
  (
    NRN                     in number   -- ���. ����� ����� �������
  ) return                  number      -- ����� ����������� ������
  is
  begin
    return STAGE_ARTS_GET_COST_FACT(NSTAGE => NRN, NFINFLOW_TYPE => 2);
  end STAGES_GET_COST_FACT;
    
  /* ��������� ����� ���������� ����� ������� */
  function STAGES_GET_SUMM_REALIZ
  (
    NRN                     in number,  -- ���. ����� ����� �������
    NFPDARTCL_REALIZ        in number   -- ���. ����� ������ ����������� ��� ����������
  ) return                  number      -- ����� ����������
  is
  begin
    if (NFPDARTCL_REALIZ is not null) then
      return STAGE_ARTS_GET_COST_FACT(NSTAGE => NRN, NFPDARTCL => NFPDARTCL_REALIZ);
    else
      return 0;
    end if;
  end STAGES_GET_SUMM_REALIZ;
    
  /* ������ ������ */
  procedure STAGES_LIST
  (
    NPRN                    in number,                             -- ���. ����� �������
    NPAGE_NUMBER            in number,                             -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,                               -- �������
    CORDERS                 in clob,                               -- ����������
    NINCLUDE_DEF            in number,                             -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob                               -- ��������������� ������� ������
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- ����������� ������
    NIDENT                  PKG_STD.TREF := GEN_IDENT();           -- ������������� ������
    RF                      PKG_P8PANELS_VISUAL.TFILTERS;          -- �������
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- ����������
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- �������� �������
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- ������ �������
    RCOL_VALS               PKG_P8PANELS_VISUAL.TCOL_VALS;         -- ��������������� �������� ��������
    NROW_FROM               PKG_STD.TREF;                          -- ����� ������ �
    NROW_TO                 PKG_STD.TREF;                          -- ����� ������ ��
    NFPDARTCL_REALIZ        PKG_STD.TREF;                          -- ���. ����� ������ ����������� ��� ����������
    CSQL                    clob;                                  -- ����� ��� �������
    ICURSOR                 integer;                               -- ������ ��� ���������� �������
    NCOST_FACT              PKG_STD.TNUMBER;                       -- ����� ����������� ������ �� ����� �������
    NSUMM_REALIZ            PKG_STD.TNUMBER;                       -- ����� ���������� �� ����� �������
    NSUMM_INCOME            PKG_STD.TNUMBER;                       -- ����� ������� �� ����� �������
    NINCOME_PRC             PKG_STD.TNUMBER;                       -- ������� ������� �� ����� �������
  begin
    /* ��������� ���. ����� ������ ����������� ��� ����� ���������� */    
    FIND_FPDARTCL_CODE(NFLAG_SMART => 1, NCOMPANY => NCOMPANY, SCODE => SFPDARTCL_REALIZ, NRN => NFPDARTCL_REALIZ);
    /* ������ ������� */
    RF := PKG_P8PANELS_VISUAL.TFILTERS_FROM_XML(CFILTERS => CFILTERS);
    /* ����� ���������� */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* ����������� ����� � ������ �������� � ����� ����� � � �� */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* �������������� ������� ������ */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* ��������� � ������� �������� ������� */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => '���. �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNUMB',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDNUMB',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME',
                                               SCAPTION   => '������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDNAME',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEXPECTED_RES',
                                               SCAPTION   => '��������� ����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SFACEACC',
                                               SCAPTION   => '���� ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 0, BCLEAR => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 2);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 3);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 4);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 5);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSTATE',
                                               SCAPTION   => '���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'CGSTATE',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DBEGPLAN',
                                               SCAPTION   => '���� ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDPLANBEGFrom',
                                               SCOND_TO   => 'EDPLANBEGTo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DENDPLAN',
                                               SCAPTION   => '���� ���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDPLANENDFrom',
                                               SCOND_TO   => 'EDPLANENDTo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCOST_SUM',
                                               SCAPTION   => '���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCURNAMES',
                                               SCAPTION   => '������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NFIN_IN',
                                               SCAPTION   => '�������� ��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_NFIN_IN',
                                               SCAPTION   => '�������� �������������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_NFIN_IN',
                                               SCAPTION   => '�������� �������������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NFIN_OUT',
                                               SCAPTION   => '��������� ��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_NFIN_OUT',
                                               SCAPTION   => '��������� �������������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_NFIN_OUT',
                                               SCAPTION   => '��������� �������������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 0, BCLEAR => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_FIN',
                                               SCAPTION   => '��������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_FIN',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_CONTR',
                                               SCAPTION   => '������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_CONTR',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_COEXEC',
                                               SCAPTION   => '�������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_COEXEC',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NDAYS_LEFT',
                                               SCAPTION   => '���� �� ���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_PERIOD',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_PERIOD',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCOST_FACT',
                                               SCAPTION   => '����� ����������� ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_NCOST_FACT',
                                               SCAPTION   => '����� ����������� ������ (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_NCOST_FACT',
                                               SCAPTION   => '����� ����������� ������ (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUMM_REALIZ',
                                               SCAPTION   => '����� ����������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUMM_INCOME',
                                               SCAPTION   => '����� �������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NINCOME_PRC',
                                               SCAPTION   => '������� �������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_COST',
                                               SCAPTION   => '�������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SCOND_FROM => 'EDCTRL_COST',
                                               BORDER     => true,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);                                               
    /* ������� ������ */
    begin
      /* �������� ������ */
      CSQL := 'select *
            from (select D.*,
                         ROWNUM NROW
                    from (select PS.RN NRN,
                                 PS.NUMB SNUMB,
                                 PS.NAME SNAME,                                 
                                 PS.EXPECTED_RES SEXPECTED_RES,
                                 FAC.NUMB SFACEACC,
                                 PS.STATE NSTATE,
                                 PS.BEGPLAN DBEGPLAN,
                                 PS.ENDPLAN DENDPLAN,
                                 PS.COST_SUM_BASECURR NCOST_SUM,
                                 CN.INTCODE SCURNAMES,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_FIN_IN(PS.RN) NFIN_IN,
                                 ''Paynotes'' SLNK_UNIT_NFIN_IN,
                                 0 NLNK_DOCUMENT_NFIN_IN,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_FIN_OUT(PS.RN) NFIN_OUT,
                                 ''Paynotes'' SLNK_UNIT_NFIN_OUT,
                                 1 NLNK_DOCUMENT_NFIN_OUT,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_FIN(PS.RN) NCTRL_FIN,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_CONTR(PS.RN) NCTRL_CONTR,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_COEXEC(PS.RN) NCTRL_COEXEC,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_DAYS_LEFT(PS.RN) NDAYS_LEFT,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_PERIOD(PS.RN) NCTRL_PERIOD,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_COST_FACT(PS.RN) NCOST_FACT,
                                 ''CostNotes'' SLNK_UNIT_NCOST_FACT,
                                 1 NLNK_DOCUMENT_NCOST_FACT,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_SUMM_REALIZ(PS.RN, :NFPDARTCL_REALIZ) NSUMM_REALIZ,
                                 PKG_P8PANELS_PROJECTS.STAGES_GET_CTRL_COST(PS.RN) NCTRL_COST
                            from PROJECTSTAGE   PS,
                                 PROJECT        P,
                                 FACEACC        FAC,
                                 CURNAMES       CN
                           where PS.PRN = P.RN
                             and PS.FACEACC = FAC.RN(+)
                             and P.CURNAMES = CN.RN                             
                             and PS.RN in (select ID from COND_BROKER_IDSMART where IDENT = :NIDENT) %ORDER_BY%) D) F
           where F.NROW between :NROW_FROM and :NROW_TO';
      /* ���� ���������� */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* ���� ������� */
      PKG_P8PANELS_VISUAL.TFILTERS_SET_QUERY(NIDENT     => NIDENT,
                                             NCOMPANY   => NCOMPANY,
                                             NPARENT    => NPRN,
                                             SUNIT      => 'ProjectsStages',
                                             SPROCEDURE => 'PKG_P8PANELS_PROJECTS.STAGES_COND',
                                             RDATA_GRID => RDG,
                                             RFILTERS   => RF);
      /* ��������� ��� */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* ������ ����������� ���������� */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NIDENT', NVALUE => NIDENT);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFPDARTCL_REALIZ', NVALUE => NFPDARTCL_REALIZ);
      /* ��������� ��������� ������ ������� */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 10);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 11);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 12);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 13);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 14);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 15);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 16);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 17);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 18);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 19);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 20);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 21);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 22);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 23);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 24);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 25);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 26);      
      /* ������ ������� */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* ������� ��������� ������ */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* ��������� ������� � ������� */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SNUMB', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SNAME', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SEXPECTED_RES',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SFACEACC', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NSTATE', ICURSOR => ICURSOR, NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW => RDG_ROW, SNAME => 'DBEGPLAN', ICURSOR => ICURSOR, NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW => RDG_ROW, SNAME => 'DENDPLAN', ICURSOR => ICURSOR, NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCOST_SUM',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 9);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SCURNAMES',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 10);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NFIN_IN', ICURSOR => ICURSOR, NPOSITION => 11);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_NFIN_IN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 12);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_NFIN_IN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 13);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 14);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 15);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_NFIN_OUT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 16);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_FIN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 17);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_CONTR',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 18);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_COEXEC',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 19);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NDAYS_LEFT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 20);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_PERIOD',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 21);
        PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 22, NVALUE => NCOST_FACT);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCOST_FACT', NVALUE => NCOST_FACT);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_NCOST_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 23);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_NCOST_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 24);
        PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 25, NVALUE => NSUMM_REALIZ);
        if (NSUMM_REALIZ = 0) then
          NSUMM_INCOME := 0;
          NINCOME_PRC  := 0;
        else
          NSUMM_INCOME := NSUMM_REALIZ - NCOST_FACT;
          NINCOME_PRC  := NSUMM_INCOME / NCOST_FACT * 100;
        end if;
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSUMM_REALIZ', NVALUE => NSUMM_REALIZ);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSUMM_INCOME', NVALUE => NSUMM_INCOME);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NINCOME_PRC', NVALUE => NINCOME_PRC);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NCTRL_COST',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 26);
        /* ��������� ������ � ������� */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
      /* ����������� ������ */
      PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* ����������� �������� */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end STAGES_LIST;
  
  /* ���������� ������ �������/����� ��� ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC_LOAD_PROJECT
  (
    RPRJ                    out PROJECT%rowtype,     -- ������ �������
    RSTG                    out PROJECTSTAGE%rowtype -- ������ ����� �������
  )
  is
    NCOMPANY                PKG_STD.TREF;            -- ���. ����� ����������� �� ������� ����������
    SPROJECT_CODE           PKG_STD.TSTRING;         -- ��� ������ �� ����������
    SPROJECT_STAGE_NUMB     PKG_STD.TSTRING;         -- ����� ����� ������� �� ������� ����������
  begin
    /* ���������� ��������� "�����������" */
    PRSG_CALCTAB_IMAGE.READ_PARAMETER_NUM(SNAME => SSTAGES_CT_CALC_PRM_COMP, NVALUE => NCOMPANY);
    /* ���������� ��������� "��� �������" */
    PRSG_CALCTAB_IMAGE.READ_PARAMETER_STR(SNAME => SSTAGES_CT_CALC_PRM_PRJ, SVALUE => SPROJECT_CODE);
    /* ���������� ��������� "����� ����� �������" */
    PRSG_CALCTAB_IMAGE.READ_PARAMETER_STR(SNAME => SSTAGES_CT_CALC_PRM_STG, SVALUE => SPROJECT_STAGE_NUMB);
    /* ������ ������ */
    begin
      /* ������ */
      select P.*
        into RPRJ
        from PROJECT P
       where P.COMPANY = NCOMPANY
         and P.CODE = SPROJECT_CODE;
      /* ���� */
      select PS.*
        into RSTG
        from PROJECTSTAGE PS
       where PS.PRN = RPRJ.RN
         and trim(PS.NUMB) = trim(SPROJECT_STAGE_NUMB);
    exception
      when NO_DATA_FOUND then
        P_EXCEPTION(0,
                    '���� "%s" ������� "%s" � ����������� "%s" �� ��������.',
                    COALESCE(SPROJECT_STAGE_NUMB, '<�� ������>'),
                    COALESCE(SPROJECT_CODE, '<�� ������>'),
                    COALESCE(TO_CHAR(NCOMPANY), '<�� �������>'));
    end;
  end STAGES_CT_CALC_LOAD_PROJECT;
  
  /* ������������ ���������� ������ ��� ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC_TABLE_CAPTIONS
  is
    RPRJ                    PROJECT%rowtype;      -- ������ �������
    RSTG                    PROJECTSTAGE%rowtype; -- ������ ����� �������
  begin
    /* ������� ������ � ���� */
    STAGES_CT_CALC_LOAD_PROJECT(RPRJ => RPRJ, RSTG => RSTG);
    /* �������� �� ����� ������� */
    case PRSG_CALCTAB.TABLE_NAME
      /* ������� "������ �����������" */
      when SSTAGES_CT_CALC_TBL_CLARTS then
        PRSG_CALCTAB_BUILD.WRITE_TABLE_CAPTION(STEXT => '����������� ����� "' || trim(RSTG.NUMB) || '" ������� "' ||
                                                        RPRJ.CODE || '"');
      /* ����������� ������� */
      else
        null;
    end case;
  end STAGES_CT_CALC_TABLE_CAPTIONS;
  
  /* ������������ ����� ��� ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC_BUILD_LINES
  is
    NCOMPANY                PKG_STD.TREF;     -- ���. ����� ����������� �� ������� ����������
    NVERSION                PKG_STD.TREF;     -- ���. ����� ������ ������� "������ ������"
    SCRN                    PKG_STD.TSTRING;  -- ������������ �������� ������ ����������� � ������� "������ ������"
    NCRN                    PKG_STD.TREF;     -- ���. ����� �������� ������ ����������� � ������� "������ ������"
    BCREATED                boolean := false; -- ���� ��������� ���������� ����� � �������
  begin
    /* ������ ��� ������� "������ �����������" */
    if (PRSG_CALCTAB.TABLE_NAME = SSTAGES_CT_CALC_TBL_CLARTS) then
      /* ���������� ��������� "�����������" */
      PRSG_CALCTAB_IMAGE.READ_PARAMETER_NUM(SNAME => SSTAGES_CT_CALC_PRM_COMP, NVALUE => NCOMPANY);
      /* ���������� ��������� "������� ������ �����������" */
      PRSG_CALCTAB_IMAGE.READ_PARAMETER_STR(SNAME => SSTAGES_CT_CALC_PRM_ARTSCAT, SVALUE => SCRN);
      /* ������� ������ ������� "������ ������" */
      FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'FinPlanArticles', NVERSION => NVERSION);
      /* ������� ���. ����� �������� ������ ����������� */
      FIND_ACATALOG_NAME(NFLAG_SMART => 0,
                         NCOMPANY    => NCOMPANY,
                         NVERSION    => NVERSION,
                         SUNITCODE   => 'FinPlanArticles',
                         SNAME       => SCRN,
                         NRN         => NCRN);
      /* ���� �� ������� ����������� */
      for C in (select T.RN
                  from FPDARTCL T
                 where T.VERSION = NVERSION
                   and T.CRN = NCRN
                 order by T.CODE)
      loop
        /* ������� ������ */
        PRSG_CALCTAB_BUILD.APPEND_ROW_COPY(NSOURCE => C.RN);
        /* �������� ���� ���������� */
        BCREATED := true;
      end loop;
      /* ���� ������ �� ����� */
      if (not BCREATED) then
        P_EXCEPTION(0, '�� ����� ����� ������ �����������.');
      end if;
    end if;
  end STAGES_CT_CALC_BUILD_LINES;
    
  /* ���������� ����� ��� ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC_FILL_LINES
  is
    RCURSOR                 PRSG_CALCTAB.TCURSOR; -- ������ ��������� ����� �������
    RFPDARTCL               FPDARTCL%rowtype;     -- ������ ������ ����������� � �������
    NSUMM_PL                PKG_STD.TNUMBER;      -- �������� ����� (��������� �� ��������� ��������� �������)
  begin
    /* ����� ����� � ������� "������ �����������"*/
    PRSG_CALCTAB_IMAGE.SELECT_TABLE(SSHEET_NAME => SSTAGES_CT_CALC_SH_CACL, STABLE_NAME => SSTAGES_CT_CALC_TBL_CLARTS);
    /* ������ ������ */
    PRSG_CALCTAB_IMAGE.FIRST_ROW(SROW_NAME => SSTAGES_CT_CALC_LN_ARTS, RCURSOR => RCURSOR);
    /* ���� �� ������� */
    loop
      /* C������ ������ */
      begin
        select A.* into RFPDARTCL from FPDARTCL A where A.RN = RCURSOR.ROW_SOURCE;
      exception
        when NO_DATA_FOUND then
          PKG_MSG.RECORD_NOT_FOUND(NFLAG_SMART => 0, NDOCUMENT => RCURSOR.ROW_SOURCE, SUNIT_TABLE => 'FPDARTCL');
      end;
      /* ��������� ������� - "�����" */
      PRSG_CALCTAB_IMAGE.WRITE_ROW_STR(RCURSOR      => RCURSOR,
                                       SCOLUMN_NAME => SSTAGES_CT_CALC_CL_NUMB,
                                       SVALUE       => RFPDARTCL.CODE,
                                       NSOURCE      => RFPDARTCL.RN);
      /* ��������� ������� - "������������" */
      PRSG_CALCTAB_IMAGE.WRITE_ROW_STR(RCURSOR      => RCURSOR,
                                       SCOLUMN_NAME => SSTAGES_CT_CALC_CL_NAME,
                                       SVALUE       => RFPDARTCL.NAME,
                                       NSOURCE      => RFPDARTCL.RN);
      /* ��������� ������� - "�������� �����" */
      PRSG_CALCTAB_IMAGE.READ_ROW_NUM(RCURSOR      => RCURSOR,
                                      SCOLUMN_NAME => SSTAGES_CT_CALC_CL_SUMM_PL,
                                      NVALUE       => NSUMM_PL);
      PRSG_CALCTAB_IMAGE.WRITE_ROW_NUM(RCURSOR      => RCURSOR,
                                       SCOLUMN_NAME => SSTAGES_CT_CALC_CL_SUMM_PL,
                                       NVALUE       => COALESCE(NSUMM_PL, 0),
                                       NSOURCE      => RFPDARTCL.RN);
      /* ������� ���� ����� ������ ��� */
      if (not PRSG_CALCTAB_IMAGE.NEXT_ROW(RCURSOR => RCURSOR)) then
        exit;
      end if;
    end loop;
  end STAGES_CT_CALC_FILL_LINES;
  
  /* ������������ ��������� ������� "PM0010" - "����������� ����� �������" */
  procedure STAGES_CT_CALC
  is
  begin
    /* �������� � ����������� �� �������� ������ ������ */
    case
      /* ������������� ���������� */
      when (PRSG_CALCTAB.CONTEXT_INIT) then
        null;
      /* ������������ ���������� ������ */
      when (PRSG_CALCTAB.CONTEXT_SHEET_CAPTION) then
        null;
      /* ������������ ���������� ������ */
      when (PRSG_CALCTAB.CONTEXT_TABLE_CAPTION) then
        STAGES_CT_CALC_TABLE_CAPTIONS();
      /* ������������ �������� */
      when (PRSG_CALCTAB.CONTEXT_COLUMN_CAPTION) then
        null;
      /* ������������ ����� */
      when (PRSG_CALCTAB.CONTEXT_ROW_COPIES) then
        STAGES_CT_CALC_BUILD_LINES();
      /* ���������� ������� */
      when (PRSG_CALCTAB.CONTEXT_BEFORE) then        
        STAGES_CT_CALC_FILL_LINES();
      /* ���������� */
      when (PRSG_CALCTAB.CONTEXT_AFTER) then        
        null;
      /* ������ */
      else
        null;
    end case;
  end STAGES_CT_CALC;
  
  /* ������ ������� ������� ������ �� ������ ����������� ����� ������� */
  procedure STAGE_ARTS_SELECT_COST_FACT
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ����������� (null - �� ����)
    NFINFLOW_TYPE           in number := null, -- ��� �������� �� ������ (null - �� ����, 0 - �������, 1 - ������, 2 - ������)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  )
  is
    NSELECTLIST             PKG_STD.TREF;      -- ���. ����� ����������� ������ ������ �����������
  begin
    /* ������� ������ ������� ������ */
    for C in (select CN.COMPANY,
                     CN.RN
                from PROJECTSTAGE PS,
                     FCCOSTNOTES  CN,
                     FINSTATE     FS,
                     FPDARTCL     FA,
                     FINFLOWTYPE  FT
               where PS.RN = NSTAGE
                 and PS.FACEACC = CN.PROD_ORDER
                 and ((NFPDARTCL is null) or ((NFPDARTCL is not null) and (CN.COST_ARTICLE = NFPDARTCL)))
                 and CN.COST_TYPE = FS.RN
                 and FS.TYPE = 1
                 and CN.COST_ARTICLE = FA.RN
                 and FA.DEF_FLOW = FT.RN(+)
                 and ((NFINFLOW_TYPE is null) or ((NFINFLOW_TYPE is not null) and (FT.TYPE = NFINFLOW_TYPE))))
    loop
      /* ���������� ������������� ������ */
      if (NIDENT is null) then
        NIDENT := GEN_IDENT();
      end if;
      /* ������� ����������� � ������ ���������� ������� */
      P_SELECTLIST_BASE_INSERT(NIDENT       => NIDENT,
                               NCOMPANY     => C.COMPANY,
                               NDOCUMENT    => C.RN,
                               SUNITCODE    => 'CostNotes',
                               SACTIONCODE  => null,
                               NCRN         => null,
                               NDOCUMENT1   => null,
                               SUNITCODE1   => null,
                               SACTIONCODE1 => null,
                               NRN          => NSELECTLIST);
    end loop;
  end STAGE_ARTS_SELECT_COST_FACT;
  
  /* ��������� �����-���� �� ������ ����������� ����� ������� */
  function STAGE_ARTS_GET_COST_FACT
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ����������� (null - �� ����)
    NFINFLOW_TYPE           in number := null  -- ��� �������� �� ������ (null - �� ����, 0 - �������, 1 - ������, 2 - ������)
  ) return                  number             -- �����-���� �� ������
  is
    NRES                    PKG_STD.TNUMBER;   -- ����� ��� ����������
  begin
    /* ��������� ���� �� �������� ����� ������ ����� � ��������� ������ */
    select COALESCE(sum(CN.COST_BSUM), 0)
      into NRES
      from PROJECTSTAGE PS,
           FCCOSTNOTES  CN,
           FINSTATE     FS,
           FPDARTCL     FA,
           FINFLOWTYPE  FT
     where PS.RN = NSTAGE
       and PS.FACEACC = CN.PROD_ORDER
       and ((NFPDARTCL is null) or ((NFPDARTCL is not null) and (CN.COST_ARTICLE = NFPDARTCL)))
       and CN.COST_TYPE = FS.RN
       and FS.TYPE = 1
       and CN.COST_ARTICLE = FA.RN
       and FA.DEF_FLOW = FT.RN(+)
       and ((NFINFLOW_TYPE is null) or ((NFINFLOW_TYPE is not null) and (FT.TYPE = NFINFLOW_TYPE)));
    /* ���������� ��������� */
    return NRES;
  end STAGE_ARTS_GET_COST_FACT;

  /* ������ ������� ��������� � ��������������� �� ������ ����������� ����� ������� */
  procedure STAGE_ARTS_SELECT_CONTR
  (
    NSTAGE                  in number,         -- ���. ����� ����� �������
    NFPDARTCL               in number := null, -- ���. ����� ������ ������ (null - �� ����)
    NIDENT                  out number         -- ������������� ������ ����������� (������ ���������� �������, null - �� �������)
  )
  is
    NSELECTLIST             PKG_STD.TREF;      -- ���. ����� ����������� ������ ������ �����������
  begin
    /* ������� ������ ��������� */
    for C in (select distinct S.COMPANY NCOMPANY,
                              S.PRN     NRN
                from PROJECTSTAGEPF EPF,
                     STAGES         S
               where EPF.PRN = NSTAGE
                 and EPF.FACEACC = S.FACEACC
                 and ((NFPDARTCL is null) or ((NFPDARTCL is not null) and (EPF.COST_ARTICLE = NFPDARTCL))))
    loop
      /* ���������� ������������� ������ */
      if (NIDENT is null) then
        NIDENT := GEN_IDENT();
      end if;
      /* ������� ����������� � ������ ���������� ������� */
      P_SELECTLIST_BASE_INSERT(NIDENT       => NIDENT,
                               NCOMPANY     => C.NCOMPANY,
                               NDOCUMENT    => C.NRN,
                               SUNITCODE    => 'Contracts',
                               SACTIONCODE  => null,
                               NCRN         => null,
                               NDOCUMENT1   => null,
                               SUNITCODE1   => null,
                               SACTIONCODE1 => null,
                               NRN          => NSELECTLIST);
    end loop;
  end STAGE_ARTS_SELECT_CONTR;

  /* ��������� ����������������� ����� �� ������ ����������� ����� ������� */
  function STAGE_ARTS_GET_CONTR
  (
    NSTAGE                  in number,            -- ���. ����� ����� �������
    NFPDARTCL               in number :=null      -- ���. ����� ������ ������ (null - �� ����)
  ) return                  number                -- ����� ���������� �� ������
  is
    RSTG                    PROJECTSTAGE%rowtype; -- ������ �����
    NTAX_GROUP_DP           PKG_STD.TREF;         -- ���. ����� ���. �������� ��� ��������� ������ �������
    SPRJ_TAX_GROUP          PKG_STD.TSTRING;      -- ��������� ������ �������
    NSUM                    PKG_STD.TNUMBER;      -- ����� ���������� (��� �������)
    NSUM_TAX                PKG_STD.TNUMBER;      -- ����� ���������� (� ��������)
  begin
    /* ������� ������ ����� */
    begin
      select PS.* into RSTG from PROJECTSTAGE PS where PS.RN = NSTAGE;
    exception
      when NO_DATA_FOUND then
        null;
    end;
    /* ���� ������� ������� - ����� ������ ������ */
    if (RSTG.RN is not null) then
      /* ��������� ���. ����� ���. �������� ��� ��������� ������ ������� */
      FIND_DOCS_PROPS_CODE(NFLAG_SMART => 1,
                           NCOMPANY    => RSTG.COMPANY,
                           SCODE       => '���.TAX_GROUP',
                           NRN         => NTAX_GROUP_DP);
      /* ������� ��������� ������ ������� */
      SPRJ_TAX_GROUP := F_DOCS_PROPS_GET_STR_VALUE(NPROPERTY => NTAX_GROUP_DP,
                                                   SUNITCODE => 'Projects',
                                                   NDOCUMENT => RSTG.PRN);
      /* ������� ����� ������ ��������� � ��������������� */
      select COALESCE(sum(S.STAGE_SUM), 0),
             COALESCE(sum(S.STAGE_SUMTAX), 0)
        into NSUM,
             NSUM_TAX
        from PROJECTSTAGEPF EPF,
             STAGES         S
       where EPF.PRN = RSTG.RN
         and EPF.FACEACC = S.FACEACC
         and ((NFPDARTCL is null) or ((NFPDARTCL is not null) and (EPF.COST_ARTICLE = NFPDARTCL)));
      /* ����� ����� � ����������� �� ��������� ������ ������� */
      if (SPRJ_TAX_GROUP is not null) then
        return NSUM;
      else
        return NSUM_TAX;
      end if;
    else
      return 0;
    end if;
  end STAGE_ARTS_GET_CONTR;
  
  /* ��������� ������ ������ ����� ������� */
  procedure STAGE_ARTS_GET
  (
    NSTAGE                  in number,            -- ���. ����� ����� �������  
    NINC_COST               in number := 0,       -- �������� �������� � �������� (0 - ���, 1 - ��)
    NINC_CONTR              in number := 0,       -- �������� �������� � ������������ (0 - ���, 1 - ��)
    RSTAGE_ARTS             out TSTAGE_ARTS       -- ������ ������ ����� �������
  )
  is
    RSTG                    PROJECTSTAGE%rowtype; -- ������ ����� �������
    NCTL_COST_DP            PKG_STD.TREF;         -- ���. ����� ���. ��������, ������������� ������������� �������� ������ �� ������
    NCTL_CONTR_DP           PKG_STD.TREF;         -- ���. ����� ���. ��������, ������������� ������������� �������� ������������ �� ������
    I                       PKG_STD.TNUMBER;      -- ������� ������ � �������������� ���������
  begin
    /* ������ ���� */
    RSTG := STAGES_GET(NRN => NSTAGE);
    /* ��������� �������������� �������� - �������� ������ */
    if (NINC_COST = 1) then
      FIND_DOCS_PROPS_CODE(NFLAG_SMART => 1, NCOMPANY => RSTG.COMPANY, SCODE => '���.CTL_COST', NRN => NCTL_COST_DP);
    end if;
    /* ��������� �������������� �������� - �������� ������������ */
    if (NINC_CONTR = 1) then
      FIND_DOCS_PROPS_CODE(NFLAG_SMART => 1,
                           NCOMPANY    => RSTG.COMPANY,
                           SCODE       => '���.CTL_CONTR',
                           NRN         => NCTL_CONTR_DP);
    end if;
    /* �������������� ��������� */
    RSTAGE_ARTS := TSTAGE_ARTS();
    /* ��������� �������� ��������� ���� ����� ������� � � ������� ������ */
    for C in (select CSPA.NUMB     SNUMB,
                     A.RN          NARTICLE,
                     A.NAME        SARTICLE,
                     CSPA.COST_SUM NCOST_SUM
                from PROJECTSTAGE  PS,
                     STAGES        CS,
                     CONTRPRSTRUCT CSP,
                     CONTRPRCLC    CSPA,
                     FPDARTCL      A
               where PS.RN = RSTG.RN
                 and PS.FACEACCCUST = CS.FACEACC
                 and CSP.PRN = CS.RN
                 and CSP.SIGN_ACT = 1
                 and CSPA.PRN = CSP.RN
                 and CSPA.COST_ARTICLE = A.RN
               order by CSPA.NUMB)
    loop
      /* ������� ������ � ��������� */
      RSTAGE_ARTS.EXTEND();
      I := RSTAGE_ARTS.LAST;
      /* �������� � ���������� �� ��������� */
      RSTAGE_ARTS(I).NRN := C.NARTICLE;
      RSTAGE_ARTS(I).SCODE := C.SNUMB;
      RSTAGE_ARTS(I).SNAME := C.SARTICLE;
      RSTAGE_ARTS(I).NPLAN := C.NCOST_SUM;
      /* ���� ������� �������� �������� � �������� � ������ ������������ ���  */
      if ((NINC_COST = 1) and
         (UPPER(F_DOCS_PROPS_GET_STR_VALUE(NPROPERTY => NCTL_COST_DP,
                                            SUNITCODE => 'FinPlanArticles',
                                            NDOCUMENT => RSTAGE_ARTS(I).NRN)) = UPPER(SYES)) and
         (RSTAGE_ARTS(I).NPLAN is not null)) then
        /* ����������� ������� �� ������ */
        RSTAGE_ARTS(I).NCOST_FACT := STAGE_ARTS_GET_COST_FACT(NSTAGE => NSTAGE, NFPDARTCL => RSTAGE_ARTS(I).NRN);
        /* ���������� ������ (����-����) */
        RSTAGE_ARTS(I).NCOST_DIFF := RSTAGE_ARTS(I).NPLAN - RSTAGE_ARTS(I).NCOST_FACT;
        /* �������� ������ */
        if (RSTAGE_ARTS(I).NCOST_DIFF >= 0) then
          RSTAGE_ARTS(I).NCTRL_COST := 0;
        else
          RSTAGE_ARTS(I).NCTRL_COST := 1;
        end if;
      end if;
      /* ���� ������� �������� �������� � ���������� � ������ ������������ ��� */
      if ((NINC_CONTR = 1) and
         (UPPER(F_DOCS_PROPS_GET_STR_VALUE(NPROPERTY => NCTL_CONTR_DP,
                                            SUNITCODE => 'FinPlanArticles',
                                            NDOCUMENT => RSTAGE_ARTS(I).NRN)) = UPPER(SYES)) and
         (RSTAGE_ARTS(I).NPLAN is not null)) then
        /* ��������������� */
        RSTAGE_ARTS(I).NCONTR := STAGE_ARTS_GET_CONTR(NSTAGE => NSTAGE, NFPDARTCL => RSTAGE_ARTS(I).NRN);
        /* �������� ��������������� */
        RSTAGE_ARTS(I).NCONTR_LEFT := RSTAGE_ARTS(I).NPLAN - RSTAGE_ARTS(I).NCONTR;
        /* �������� ������������ */
        if (RSTAGE_ARTS(I).NCONTR_LEFT >= 0) then
          RSTAGE_ARTS(I).NCTRL_CONTR := 0;
        else
          RSTAGE_ARTS(I).NCTRL_CONTR := 1;
        end if;
      end if;
    end loop;
  end STAGE_ARTS_GET;
  
  /* ������ ������ ����������� ����� ������� */
  procedure STAGE_ARTS_LIST
  (
    NSTAGE                  in number,                      -- ���. ����� ����� �������
    CFILTERS                in clob,                        -- �������
    NINCLUDE_DEF            in number,                      -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob                        -- ��������������� ������� ������
  )
  is
    RF                      PKG_P8PANELS_VISUAL.TFILTERS;   -- �������
    RF_CTRL_COST            PKG_P8PANELS_VISUAL.TFILTER;    -- ������ �� ������� "�������� (�������)"
    NCTRL_COST_FROM         PKG_STD.TNUMBER;                -- ������ ������� ��������� ������� �� ������� "�������� (�������)"
    NCTRL_COST_TO           PKG_STD.TNUMBER;                -- ������� ������� ��������� ������� �� ������� "�������� (�������)"
    RF_CTRL_CONTR           PKG_P8PANELS_VISUAL.TFILTER;    -- ������ �� ������� "�������� (������������)"
    NCTRL_CONTR_FROM        PKG_STD.TNUMBER;                -- ������ ������� ��������� ������� �� ������� "�������� (������������)"
    NCTRL_CONTR_TO          PKG_STD.TNUMBER;                -- ������� ������� ��������� ������� �� ������� "�������� (������������)"
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID; -- �������� �������
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;       -- ������ �������
    RCOL_VALS               PKG_P8PANELS_VISUAL.TCOL_VALS;  -- ��������������� �������� ��������
    RSTAGE_ARTS             TSTAGE_ARTS;                    -- ������ ������ ����� �������
  begin
    /* ������ ������� */
    RF := PKG_P8PANELS_VISUAL.TFILTERS_FROM_XML(CFILTERS => CFILTERS);
    /* ������ ������ �� �������� ������ */
    RF_CTRL_COST := PKG_P8PANELS_VISUAL.TFILTERS_FIND(RFILTERS => RF, SNAME => 'NCTRL_COST');
    PKG_P8PANELS_VISUAL.TFILTER_TO_NUMBER(RFILTER => RF_CTRL_COST, NFROM => NCTRL_COST_FROM, NTO => NCTRL_COST_TO);
    /* ������ ������ �� �������� ������������ */
    RF_CTRL_CONTR := PKG_P8PANELS_VISUAL.TFILTERS_FIND(RFILTERS => RF, SNAME => 'NCTRL_CONTR');
    PKG_P8PANELS_VISUAL.TFILTER_TO_NUMBER(RFILTER => RF_CTRL_CONTR, NFROM => NCTRL_CONTR_FROM, NTO => NCTRL_CONTR_TO);
    /* �������������� ������� ������ */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* ��������� � ������� �������� ������� */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => '���. �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNUMB',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME',
                                               SCAPTION   => '������������ ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPLAN',
                                               SCAPTION   => '����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCOST_FACT',
                                               SCAPTION   => '����������� �������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCOST_DIFF',
                                               SCAPTION   => '���������� �� ��������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 0, BCLEAR => true);
    PKG_P8PANELS_VISUAL.TCOL_VALS_ADD(RCOL_VALS => RCOL_VALS, NVALUE => 1);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_COST',
                                               SCAPTION   => '�������� (�������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCONTR',
                                               SCAPTION   => '���������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCONTR_LEFT',
                                               SCAPTION   => '�������� ���������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCTRL_CONTR',
                                               SCAPTION   => '�������� (������������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BFILTER    => true,
                                               RCOL_VALS  => RCOL_VALS);
    /* ���������� �������� �� ������ ����� �������  */
    STAGE_ARTS_GET(NSTAGE => NSTAGE, NINC_COST => 1, NINC_CONTR => 1, RSTAGE_ARTS => RSTAGE_ARTS);
    /* ������� ��������� ������ */
    if ((RSTAGE_ARTS is not null) and (RSTAGE_ARTS.COUNT > 0)) then
      for I in RSTAGE_ARTS.FIRST .. RSTAGE_ARTS.LAST
      loop
        /* ���� ������ ������ */
        if (((NCTRL_COST_FROM is null) or
           ((NCTRL_COST_FROM is not null) and (NCTRL_COST_FROM = RSTAGE_ARTS(I).NCTRL_COST))) and
           ((NCTRL_CONTR_FROM is null) or
           ((NCTRL_CONTR_FROM is not null) and (NCTRL_CONTR_FROM = RSTAGE_ARTS(I).NCTRL_CONTR)))) then
          /* ��������� ������� � ������� */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                           SNAME  => 'NRN',
                                           NVALUE => RSTAGE_ARTS(I).NRN,
                                           BCLEAR => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'SNUMB', SVALUE => RSTAGE_ARTS(I).SCODE);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'SNAME', SVALUE => RSTAGE_ARTS(I).SNAME);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NPLAN', NVALUE => RSTAGE_ARTS(I).NPLAN);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCOST_FACT', NVALUE => RSTAGE_ARTS(I).NCOST_FACT);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCOST_DIFF', NVALUE => RSTAGE_ARTS(I).NCOST_DIFF);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCTRL_COST', NVALUE => RSTAGE_ARTS(I).NCTRL_COST);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCONTR', NVALUE => RSTAGE_ARTS(I).NCONTR);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                           SNAME  => 'NCONTR_LEFT',
                                           NVALUE => RSTAGE_ARTS(I).NCONTR_LEFT);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                           SNAME  => 'NCTRL_CONTR',
                                           NVALUE => RSTAGE_ARTS(I).NCTRL_CONTR);
          /* ��������� ������ � ������� */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end if;
      end loop;
    end if;
    /* ����������� �������� */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end STAGE_ARTS_LIST;

  /* ������ ��������� ����� ������� */
  procedure STAGE_CONTRACTS_COND
  is
  begin
    /* ��������� ������� ������� */
    PKG_COND_BROKER.SET_TABLE(STABLE_NAME => 'PROJECTSTAGEPF');
    /* ���� ������� */
    PKG_COND_BROKER.SET_COLUMN_PRN(SCOLUMN_NAME => 'PRN');
    /* ������������� */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME    => 'AGNNAME',
                                       SCONDITION_NAME => 'EDAGENT',
                                       SJOINS          => 'PERFORMER <- RN;AGNLIST');
    /* ������ ������ */
    PKG_COND_BROKER.ADD_CONDITION_CODE(SCOLUMN_NAME    => 'CODE',
                                       SCONDITION_NAME => 'EDSCOST_ART',
                                       SJOINS          => 'COST_ARTICLE <- RN;FPDARTCL');
    /* ������ - ���� �������� */
    PKG_COND_BROKER.SET_GROUP(SGROUP_NAME         => 'STAGES',
                              STABLE_NAME         => 'STAGES',
                              SCOLUMN_NAME        => 'FACEACC',
                              SPARENT_COLUMN_NAME => 'FACEACC');
    /* ���� �������� - ����� ����� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_CODE(SGROUP_NAME     => 'STAGES',
                                             SCOLUMN_NAME    => 'NUMB',
                                             SCONDITION_NAME => 'EDSTAGE',
                                             IALIGN          => 20);
    /* ���� �������� - ���� ������ ����� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_BETWEEN(SGROUP_NAME          => 'STAGES',
                                                SCOLUMN_NAME         => 'BEGIN_DATE',
                                                SCONDITION_NAME_FROM => 'EDCSTAGE_BEGIN_DATEFrom',
                                                SCONDITION_NAME_TO   => 'EDCSTAGE_BEGIN_DATETo');
    /* ���� �������� - ���� ��������� ����� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_BETWEEN(SGROUP_NAME          => 'STAGES',
                                                SCOLUMN_NAME         => 'END_DATE',
                                                SCONDITION_NAME_FROM => 'EDCSTAGE_END_DATEFrom',
                                                SCONDITION_NAME_TO   => 'EDCSTAGE_END_DATETo');
    /* ���� �������� - ������� �������� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_CODE(SGROUP_NAME     => 'STAGES',
                                             SCOLUMN_NAME    => 'DOC_PREF',
                                             SCONDITION_NAME => 'EDDOC_PREF',
                                             SJOINS          => 'PRN <- RN;CONTRACTS',
                                             IALIGN          => 80);
    /* ���� �������� - ����� �������� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_CODE(SGROUP_NAME     => 'STAGES',
                                             SCOLUMN_NAME    => 'DOC_NUMB',
                                             SCONDITION_NAME => 'EDDOC_NUMB',
                                             SJOINS          => 'PRN <- RN;CONTRACTS',
                                             IALIGN          => 80);
    /* ���� �������� - ���� �������� */
    PKG_COND_BROKER.ADD_GROUP_CONDITION_BETWEEN(SGROUP_NAME          => 'STAGES',
                                                SCOLUMN_NAME         => 'DOC_DATE',
                                                SCONDITION_NAME_FROM => 'EDDOC_DATEFrom',
                                                SCONDITION_NAME_TO   => 'EDDOC_DATETo',
                                                SJOINS               => 'PRN <- RN;CONTRACTS');
  end STAGE_CONTRACTS_COND;

  /* ������ ��������� ����� ������� */
  procedure STAGE_CONTRACTS_LIST
  (
    NSTAGE                  in number,                             -- ���. ����� ����� �������
    NPAGE_NUMBER            in number,                             -- ����� �������� (������������ ��� NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- ���������� ������� �� �������� (0 - ���)
    CFILTERS                in clob,                               -- �������
    CORDERS                 in clob,                               -- ����������
    NINCLUDE_DEF            in number,                             -- ������� ��������� �������� ������� ������� � �����
    COUT                    out clob                               -- ��������������� ������� ������
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- ����������� ������
    NIDENT                  PKG_STD.TREF := GEN_IDENT();           -- ������������� ������
    RF                      PKG_P8PANELS_VISUAL.TFILTERS;          -- �������
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- ����������
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- �������� �������
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- ������ �������
    NROW_FROM               PKG_STD.TREF;                          -- ����� ������ �
    NROW_TO                 PKG_STD.TREF;                          -- ����� ������ ��
    CSQL                    clob;                                  -- ����� ��� �������
    ICURSOR                 integer;                               -- ������ ��� ���������� �������
  begin
    /* ������ ������� */
    RF := PKG_P8PANELS_VISUAL.TFILTERS_FROM_XML(CFILTERS => CFILTERS);
    /* ����� ���������� */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* ����������� ����� � ������ �������� � ����� ����� � � �� */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* �������������� ������� ������ */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* ��������� � ������� �������� ������� */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => '���. �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_PREF',
                                               SCAPTION   => '�������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDDOC_PREF',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_SDOC_PREF',
                                               SCAPTION   => '������� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_SDOC_PREF',
                                               SCAPTION   => '������� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_NUMB',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDDOC_NUMB',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SLNK_UNIT_SDOC_NUMB',
                                               SCAPTION   => '����� (��� ������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLNK_DOCUMENT_SDOC_NUMB',
                                               SCAPTION   => '����� (�������� ������)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDOC_DATE',
                                               SCAPTION   => '����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDDOC_DATEFrom',
                                               SCOND_TO   => 'EDDOC_DATETo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEXT_NUMBER',
                                               SCAPTION   => '������� �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SAGENT',
                                               SCAPTION   => '�������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDAGENT',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SAGENT_INN',
                                               SCAPTION   => '��� �������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SAGENT_KPP',
                                               SCAPTION   => '��� �������������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SGOVCNTRID',
                                               SCAPTION   => '���',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCSTAGE',
                                               SCAPTION   => '����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDSTAGE',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCSTAGE_DESCRIPTION',
                                               SCAPTION   => '�������� �����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DCSTAGE_BEGIN_DATE',
                                               SCAPTION   => '���� ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDCSTAGE_BEGIN_DATEFrom',
                                               SCOND_TO   => 'EDCSTAGE_BEGIN_DATETo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DCSTAGE_END_DATE',
                                               SCAPTION   => '���� ���������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               SCOND_FROM => 'EDCSTAGE_END_DATEFrom',
                                               SCOND_TO   => 'EDCSTAGE_END_DATETo',
                                               BORDER     => true,
                                               BFILTER    => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUMM',
                                               SCAPTION   => '�����',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCURR',
                                               SCAPTION   => '������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCOST_ART',
                                               SCAPTION   => '������ ������',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               SCOND_FROM => 'EDSCOST_ART',
                                               BORDER     => true,
                                               BFILTER    => true);
    /* ������� ������ */
    begin
      /* �������� ������ */
      CSQL := 'select *
            from (select D.*,
                         ROWNUM NROW
                    from (select PSPF.RN NRN,
                                 trim(CN.DOC_PREF) SDOC_PREF,
                                 ''Contracts'' SLNK_UNIT_SDOC_PREF,
                                 CN.RN NLNK_DOCUMENT_SDOC_PREF,
                                 trim(CN.DOC_NUMB) SDOC_NUMB,
                                 ''Contracts'' SLNK_UNIT_SDOC_NUMB,
                                 CN.RN NLNK_DOCUMENT_SDOC_NUMB,
                                 CN.DOC_DATE DDOC_DATE,
                                 CN.EXT_NUMBER SEXT_NUMBER,
                                 AG.AGNNAME SAGENT,
                                 AG.AGNIDNUMB SAGENT_INN,
                                 AG.REASON_CODE SAGENT_KPP,
                                 ''"'' || GC.CODE || ''"'' SGOVCNTRID,
                                 trim(ST.NUMB) SCSTAGE,
                                 ST.DESCRIPTION SCSTAGE_DESCRIPTION,
                                 ST.BEGIN_DATE DCSTAGE_BEGIN_DATE,
                                 ST.END_DATE DCSTAGE_END_DATE,
                                 PSPF.COST_PLAN NSUMM,
                                 CUR.INTCODE SCURR,
                                 ART.CODE SCOST_ART
                            from PROJECTSTAGEPF PSPF,
                                 STAGES         ST,
                                 CONTRACTS      CN,
                                 AGNLIST        AG,
                                 CURNAMES       CUR,
                                 FPDARTCL       ART,
                                 GOVCNTRID      GC
                           where PSPF.FACEACC = ST.FACEACC
                             and ST.PRN = CN.RN
                             and PSPF.PERFORMER = AG.RN
                             and CN.CURRENCY = CUR.RN
                             and PSPF.COST_ARTICLE = ART.RN(+)
                             and CN.GOVCNTRID = GC.RN(+)                             
                             and PSPF.RN in (select ID from COND_BROKER_IDSMART where IDENT = :NIDENT) %ORDER_BY%) D) F
           where F.NROW between :NROW_FROM and :NROW_TO';
      /* ���� ���������� */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* ���� ������� */
      PKG_P8PANELS_VISUAL.TFILTERS_SET_QUERY(NIDENT     => NIDENT,
                                             NCOMPANY   => NCOMPANY,
                                             NPARENT    => NSTAGE,
                                             SUNIT      => 'ProjectsStagesPerformers',
                                             SPROCEDURE => 'PKG_P8PANELS_PROJECTS.STAGE_CONTRACTS_COND',
                                             RDATA_GRID => RDG,
                                             RFILTERS   => RF);
      /* ��������� ��� */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* ������ ����������� ���������� */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NIDENT', NVALUE => NIDENT);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      /* ��������� ��������� ������ ������� */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 10);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 11);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 12);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 13);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 14);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 15);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 16);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 17);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 18);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 19);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 20);
      /* ������ ������� */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* ������� ��������� ������ */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* ��������� ������� � ������� */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOC_PREF',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_SDOC_PREF',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_SDOC_PREF',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOC_NUMB',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SLNK_UNIT_SDOC_NUMB',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLNK_DOCUMENT_SDOC_NUMB',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DDOC_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SEXT_NUMBER',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 9);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SAGENT', ICURSOR => ICURSOR, NPOSITION => 10);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SAGENT_INN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 11);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SAGENT_KPP',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 12);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SGOVCNTRID',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 13);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SCSTAGE', ICURSOR => ICURSOR, NPOSITION => 14);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SCSTAGE_DESCRIPTION',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 15);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DCSTAGE_BEGIN_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 16);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DCSTAGE_END_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 17);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NSUMM', ICURSOR => ICURSOR, NPOSITION => 18);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SCURR', ICURSOR => ICURSOR, NPOSITION => 19);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SCOST_ART',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 20);
        /* ��������� ������ � ������� */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
      /* ����������� ������ */
      PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* ����������� �������� */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end STAGE_CONTRACTS_LIST;

end PKG_P8PANELS_PROJECTS;
/

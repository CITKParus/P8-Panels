create or replace package PKG_P8PANELS as

  /* ���������� �������� ���������� ���������� */
  procedure PROCESS
  (
    CIN                     in clob,    -- ������� ���������
    COUT                    out clob    -- ���������
  );

end PKG_P8PANELS;
/
create or replace package body PKG_P8PANELS as

  /* ���������� �������� ���������� ���������� */
  procedure PROCESS
  (
    CIN                     in clob,    -- ������� ���������
    COUT                    out clob    -- ���������
  )
  is
  begin
    /* ������� ���������� �������� */
    PKG_P8PANELS_BASE.PROCESS(CIN => CIN, COUT => COUT);
  end PROCESS;

end PKG_P8PANELS;
/

call main()

' 
' �T�v�F���ϐ��l���擾
' �����Fenv_name/���ϐ���(%�Ȃ�)
' �ߒl�Fstring/���ϐ��l
' ���l�F
'
function getEnv(env_name)
  Dim objShell
  
  '�V�F���I�u�W�F�N�g�쐬
  Set objShell = CreateObject("WScript.Shell")
  
  '���ϐ��擾
  getEnv = objShell.ExpandEnvironmentStrings("%" & env_name & "%")
end Function

' 
' �T�v�FCSV Load �pSQL�t�@�C������
' �����Ffilename/CSV�t�@�C����
' �ߒl�Fboolean/True:����AFalse:�ُ�
' ���l�F
'
function createSalesBudgetLoadDataFile(filename)
  Dim fso
  Dim file
  Dim sql_file
  Dim data_file

  '�t�@�C���V�X�e���I�u�W�F�N�g����
  set fso = createObject("Scripting.FileSystemObject")

  '�쐬����SQL�t�@�C�����𐶐�
  sql_file = getEnv("BAT_ROOT_PATH") & getEnv("SQL_PATH") & getEnv("SQL_FILE_NAME")

  '�C���|�[�g����CSV�t�@�C�����𐶐�
  data_file = getEnv("CONTAINER_LOAD_FILE_PATH") & filename

  '�o�̓t�@�C���쐬
  set file = fso.createTextFile(sql_file, true)

  'LOAD DATA ���̏o��
  file.writeline "set character_set_database=cp932;"
  file.writeline "load data"
  file.writeline "infile '" & data_file & "'"
  file.writeline "into table sales_budget"
  file.writeline "fields terminated by ','"
  file.writeline "enclosed by '""'"
  file.writeline "lines terminated by '\r\n'"
  file.writeline "ignore 1 rows"
  file.writeline "(@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16)"
  file.writeline "set created=now(), updated=now(), accounting_period=@1, version=@2, sales_department=@3, classification=@4, sales_representative=@5, supervising_department=@6, client_name=@7, project_name=@8, operator=@9, accounting_month=@10, sales_budget=@11, sales_expected=@12, sales_achievement=@13, half_period=@14, quarter=@15, accuracy=@16;"

  file.close()
end Function

function main()
Dim fso
Dim path
Dim file
Dim excelApp
Dim wb
Dim ws
Dim r
Dim cols
Dim i
Dim expected
Dim budget
Dim years
Dim halfyear
Dim quarter
Dim accuracy
Dim objargs
Dim target
Dim current_version
Dim filename

wscript.echo now() & ", �����J�n"

'�t�@�C���V�X�e���I�u�W�F�N�g����
set fso = createObject("Scripting.FileSystemObject")

'���ʃp�X�̐���
'path = fso.GetAbsolutePathName("C:\workspace\docker-django_mysql\src\batch")
'BAT �t�@�C���ɂĊ��ϐ���ݒ肷��d�l�ɕύX
path = getEnv("BAT_ROOT_PATH")

'�R�}���h���C�������̎擾
set objargs = wscript.arguments

if objargs.count <> 2 then
  wscript.echo "�R�}���h���C���������������w�肳��Ă��܂���"
  exit function
end if

'�t�@�C���̗L��
target = path & getEnv("INPUT_PATH") & objargs(0) & "��\" & objargs(0) & "������\�Z_�c�Ǝ���.xlsm"

if fso.FileExists(target) then
  'Excel�̃C���X�^���X�̐���
  set excelApp = CreateObject("Excel.Application")

  'Excel �t�@�C�����J��
  set wb = excelApp.Workbooks.open(target, , true) 
else
  wscript.echo "�t�@�C�������݂��܂���"
  exit function
end if

if objargs(1) = 1 then
  current_version = getCurVerupValue(objargs(0))
elseif objargs(1) = 2 then
  call UpSecHalfValue(objargs(0))
  current_version = getCurVerupValue(objargs(0))
end if

'�o�̓t�@�C�����J��
'set file = fso.createTextFile(path & "\output\" & objargs(0) & "_sales_budget_" & format(now) & ".csv", true)

'�o�̓t�@�C�����̐���
filename = objargs(0) & "_" & current_version & "_sales_budget.csv"

'LOAD DATA SQL�t�@�C���̐���
call createSalesBudgetLoadDataFile(filename)

'�o�̓t�@�C���쐬
set file = fso.createTextFile(path & getEnv("OUTPUT_PATH") & filename, true)

'�^�C�g���s�̏o��
file.writeline """accounting_period"",""version"",""sales_department"",""classification"",""sales_representative"",""supervising_department"",""client_name"",""project_name"",""operator"",""accounting_month"",""sales_budget"",""sales_expected"",""sales_achievement"",""half_period"",""quarter"",""accuracy"""

'�ǂݍ��ޗ�ԍ��̔z��
cols = array(10, 12, 14, 16, 18, 20, 24, 26, 28, 30, 32, 34)

'���[�N�V�[�g�̃��[�v
for each ws in wb.Worksheets

  if instr(ws.name, "����") > 0 then

    wscript.echo now() & ", " & ws.name

    col_b = getColBValue(ws.name)
    col_c = getColCValue(ws.name)

    '���[�N�V�[�g���̃��[�v
    r = 5
    do

      '�ŏI�s�̔���
      if ws.cells(r, "J") <> "" and ws.cells(r, "C") = "" and ws.cells(r, "F") = "" then Exit do

      '10������9��(�\�Z�����[�v����ƍs���P������j
      'for i = 0 to 11
      for i = 0 to ubound(cols)

        '�\�Z�A�����ǂ���ɂ��l���Ȃ��ꍇ�A���̃f�[�^�͑ΏۊO
        if ws.cells(r, cols(i)) <> "" or ws.cells(r, cols(i) + 1) <> "" then

          years = getColIValue(objargs(0),i)             '�N��

          halfyear = getColMValue(cols(i))               '����

          quarter = getColNValue(cols(i))                '�l����

          if ws.cells(r,cols(i))= "" then                '�\�Z
            budget = "0"
          else
            budget = ws.cells(r,cols(i)) 
          end if

          if ws.cells(r, cols(i) + 1) = "" then            '����
            expected = "0"
          else
            expected = ws.cells(r, cols(i) + 1)
          end if

          if ws.cells(r,cols(i) + 1) <> "" then             '����
            achievement = expected
          else
            achievement = budget
          end if

          accuracy = ws.cells(r, 41 + i)                   '�m�x�ii�̍ŏ��l�͂O�j

          'CSV�ɏo�͂���f�[�^
          file.writeline objargs(0) & "," & current_version & ",""" & col_b & """,""" & col_c & """,""" & ws.cells(r,"E") & """,""" & ws.cells(r,"H") & """,""" & ws.cells(r,"C") & """,""" & ws.cells(r,"F") & """,""" & ws.cells(r,"I") & """,""" & years & """," & budget & "," & expected & "," & achievement & ",""" & halfyear & """,""" & quarter & """,""" & accuracy & """"

        end if
      next 
      r = r + 1
    loop    
  end if
Next

file.close
wb.close false
excelApp.Quit

wscript.echo now() & ", CVS�쐬�����I�I"

end function

function getColBValue(sheetname)
  Dim val
  Dim retval

  val = mid(sheetname,3,2)

  select case val
    case "���": retval = "1:" & val
    case "���": retval = "2:" & val
    case "�a�r": retval = "3:" & val
    case "�r�h": retval = "4:" & val
  end select

  getColBValue = retval

end function

function getColCValue(sheetname)
  Dim retval

  if instr(sheetname, "�O��") > 0 then
    retval = "2:�O��"
  elseif instr(sheetname, "����") > 0 then
    retval = "3:����"
  else
    retval = "1:�Ј�"
  end if

  getColCValue = retval

  end function

function getColIValue(workbookname,countno)
  Dim retval
  Dim yyyy

  yyyy = 1978 + workbookname
  m = array("10", "11", "12", "01", "02", "03", "04", "05", "06", "07", "08", "09")

  if  countno <= 2 then
    retval = yyyy & m(countno)
  else
    retval = (yyyy +  1) & m(countno)
  end if

  getColIValue = retval

end function

function getColMValue(columnno)
  Dim retval

  select case columnno
  case 10,12,14,16,18,20:
    retval = "1:���"
  case 24,26,28,30,32,34:
    retval = "2:����"
  end select
    
    getColMvalue = retval
end function

function getColNValue(columnno)
  Dim retval

  select case columnno
  case 10, 12, 14:
    retval = "1Q"
  case 16, 18, 20:
    retval = "2Q"
  case 24, 26, 28:
    retval = "3Q"
  case 30, 32, 34:
    retval = "4Q"
  end select
    
  getColNvalue = retval
end function

function format(currenttime)
Dim retval
Dim lngyear
Dim lngmonth
Dim lngday
Dim lnghour
Dim lngminute
Dim lngsecond

  lngyear = year(currenttime)
  lngmonth = right("0" & month(currenttime),2)
  lngday = right("0" & day(currenttime),2)
  lnghour = right("0" & hour(currenttime),2)
  lngminute = right("0" & minute(currenttime),2)
  lngsecond = right("0" & second(currenttime),2)

  retval = lngyear & lngmonth & lngday & lnghour & lngminute & lngsecond

  format = retval
end function


function getCurVerValue(workbookname)

Dim con
Dim rst
Dim conStr
Dim strsql
Dim sql

'ADODB.Connection�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordset�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set rst = CreateObject("ADODB.Recordset")

'�f�[�^�x�[�X�Ƃ̐ڑ�
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'���R�[�h�Z�b�g�̃I�[�v���i SELECT �̎��s �j
rst.Open strsql, con 'SQL���̎��s

if rst.EOF then
      sql = "insert into version_control(accounting_period,current_version,first_half_version,second_half_version,updated,created) "
      sql = sql & "values(" & workbookname & ","
      sql = sql & "1,"
      sql = sql & "1,"
      sql = sql & "1,"
      sql = sql & "'" & now & "',"
      sql = sql & "'" & now & "'"
      sql = sql & ")"

    con.Execute sql

    getCurVerValue = 1

else
    getCurVerValue = rst("current_version").value
end if


'�������̉���i�����Ƃ��\��Ȃ��j
rst.Close: Set rst = Nothing
con.Close: Set con = Nothing

end function

function getCurVerupValue(workbookname)

Dim con
Dim rst
Dim conStr
Dim strsql
Dim sql

'ADODB.Connection�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordset�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set rst = CreateObject("ADODB.Recordset")

'�f�[�^�x�[�X�Ƃ̐ڑ�
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'���R�[�h�Z�b�g�̃I�[�v���i SELECT �̎��s �j
rst.Open strsql, con 'SQL���̎��s

if rst.EOF then
      sql = "insert into version_control(accounting_period,current_version,first_half_version,second_half_version,updated,created) "
      sql = sql & "values(" & workbookname & ","
      sql = sql & "1,"
      sql = sql & "1,"
      sql = sql & "1,"
      sql = sql & "now(),"
      sql = sql & "now()"
      sql = sql & ")"

    con.Execute sql

    getCurVerUpValue = 1

else
    'sql = "update version_control set current_version = " & rst("current_version").value + 1 & ","
    sql = "update version_control set current_version = current_version + 1,"
    sql = sql & "updated = now() "
    sql = sql & "where accounting_period = " & workbookname 

    con.execute sql

    getCurVerUpValue = rst("current_version").value + 1

end if


'�������̉���i�����Ƃ��\��Ȃ��j
rst.Close: Set rst = Nothing
con.Close: Set con = Nothing

end function

function UpSecHalfValue(workbookname)

Dim con
Dim rst
Dim conStr
Dim strsql
Dim sql

'ADODB.Connection�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordset�I�u�W�F�N�g��ϐ��Ɋi�[�B
Set rst = CreateObject("ADODB.Recordset")

'�f�[�^�x�[�X�Ƃ̐ڑ�
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'���R�[�h�Z�b�g�̃I�[�v���i SELECT �̎��s �j
rst.Open strsql, con 'SQL���̎��s

if rst.EOF then

  wscript.echo "���R�[�h�����݂��܂���"

else

  sql = "update version_control set second_half_version =  second_half_version + 1,"
  sql = sql & "updated = now() "
  sql = sql & "where accounting_period = " & workbookname   

  con.Execute sql

end if

end function

function SqlCon()
  Dim conStr

  conStr = "Driver={MySQL ODBC 8.0 Unicode Driver}" & _
              ";Stmt=SET CHARACTER SET SJIS" & _
              ";SERVER=" & getEnv("DB_SERVER") & _
              ";PORT=" & getEnv("DB_PORT") & _
              ";DATABASE=" & getEnv("DB_NAME") & _
              ";USER=" & getEnv("DB_USER") & _
              ";PASSWORD=" & getEnv("DB_PASSWORD") 

  SqlCon = conStr
end function

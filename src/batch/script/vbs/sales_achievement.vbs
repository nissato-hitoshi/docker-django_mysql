call main()

function main()

    '�������уf�[�^�̏���
    Dim objargs
    Dim fso
    Dim path
    Dim file
    Dim target
    Dim excelApp
    Dim wb
    Dim ws
    Dim accountingPeriodVlue
    Dim infilemonth
    Dim file_name
    dim sqlfilename

    '�R�}���h���C�������̗��p
    set objargs = wscript.arguments

    if objargs.count <> 2 then
        wscript.echo "�R�}���h���C���������Q�w�肵�Ă�������"
        exit function
    end if

    '�t�@�C���V�X�e���I�u�W�F�N�g����
    set fso = createObject("Scripting.FileSystemObject")

    '�p�X�̎擾
    path = getEnv("BAT_ROOT_PATH")

    '��v��
    accountingPeriodVlue = getColAValue(objargs(1))

    '�o�̓t�@�C���̐���
    sqlfilename = accountingPeriodVlue & "_" & objargs(1) & "_sales_achievement.csv"
    file_name = path & "\output\" & sqlfilename
    set file = fso.createTextFile(file_name, true)

    '��s�ڂ̓^�C�g�������o��
    file.writeline """accounting_period"",""project_code"",""project_name"",""client_name""," _
               & "accounting_month"",""sales_department"",""business_sector""," _
               & "supervising_department"",""amount_of_sales"",""material_cost"",""labor_cost""," _
               & "outsourcing_cost"",""expenses"",""cost_total"",""gross_profit""," _
               & "gross_profit_margin"",""type_of_contract"",""kinds"",""project_parent_code""," _
               & "project_parent_name"""

    '�ǂݍ��ރt�@�C���̌�
    infilemonth = getInfileMonth(objargs(1))

    '�ǂݍ��ރt�@�C���̃p�X
    target = path & "\input\02.����\" & accountingPeriodVlue & "��\" & objargs(1) & "\" & infilemonth & "���������уf�[�^.xlsx"

    '�t�@�C���̗L�� �������уf�[�^
    if fso.fileexists(target) then
        'Excel�̃C���X�^���X�̐���
        set excelApp = createObject("Excel.Application")

        'Excel�t�@�C�����J��
        set wb = excelApp.workbooks.open(target, ,true)
    else
        wscript.echo "�t�@�C�������݂��܂���."
        exit function
    end if

    set ws = wb.Worksheets("�������уf�[�^")

    '�ŏI�s�܂ŌJ��Ԃ�
    for r = 2 to ws.cells(1,1).end(-4121).Row   

        'CSV�ɏo�͂���f�[�^
        file.writeline accountingPeriodVlue & ",""" & ws.cells(r, "A") & """,""" & ws.cells(r, "B") & """,""" & ws.cells(r, "C") & """,""" _
            & getColEValue(ws.cells(r, "D"),accountingPeriodVlue)  & """,""" & ws.cells(r, "E") & """,""" & ws.cells(r, "F") & """,""" _ 
            & ws.cells(r, "G") & """," & ws.cells(r, "H") & "," & ws.cells(r, "I") & "," & ws.cells(r, "J") & "," _ 
            & ws.cells(r, "K") & "," & ws.cells(r, "L") & "," & ws.cells(r, "M") & "," & ws.cells(r, "N") & "," _ 
            & ws.cells(r, "O") & ",""" & ws.cells(r, "P") & """,""" & ws.cells(r, "Q") & """,""" & ws.cells(r, "R") & """,""" _ 
            & ws.cells(r, "S") & """"

    next

    file.close

    wb.close false

    excelApp.Quit

    '�ғ��������f�[�^�̏���
    call outFileNumber(objargs(1), file_name)

    '�C���|�[�g�pSQL�t�@�C���쐬
    call createSalesAchievementLoadDataFile(sqlfilename, accountingPeriodVlue)

    wscript.echo "�I���I�I"

end function


'�������сE�ғ��������F�u��v���v�̐ݒ�
function getColAValue(yyyymm)
Dim yyyy
Dim mm
Dim letval

yyyy = left(yyyymm,4) 
mm = right(yyyymm,2)

if mm >= 10 then
    letval = yyyy - 1978 
else
   letval = yyyy - 1979
end if

getColAValue = letval

end function


'�o�̓t�@�C���́u���v�̐ݒ�
function getInfileMonth(yyyymm)
Dim mm
Dim retval

mm = right(yyyymm,2)

if mm >= 10 then
    retval = mm
else
    retval = right(mm,1)
end if

getInfileMonth = retval

end function


'�o�̓t�@�C���́u���s�����v�̐ݒ�
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


'�������сF�u�v�㌎�v�̐ݒ�
function getColEValue(wsD,ki)
Dim yyyy
Dim mm
Dim letval

yyyy = ki + 1978
mm = replace(wsD,"��", "")

if mm >= 10  then
    letval = yyyy & mm
else
    letval = (yyyy + 1) & ("0" & mm)
end if

getColEValue = letval

end function



'�ғ��������f�[�^�̏���
function operatingReserves(yyyymm, filename)
Dim fso
Dim path
Dim target2
Dim accountingPeriodVlue
Dim infilemonth
Dim file
Dim excelApp
Dim wb2
Dim ws2
Dim r


'�t�@�C���V�X�e���I�u�W�F�N�g����
set fso = createObject("Scripting.FileSystemObject")

'�p�X�̎擾
path = getEnv("BAT_ROOT_PATH")

'��v��
accountingPeriodVlue = getColAValue(yyyymm)    

'�ǂݍ��ރt�@�C���̌�
infilemonth = getInfileMonth(yyyymm)             

'�o�̓t�@�C���֒ǉ�
set file = fso.OpenTextFile(filename, 8)

'�ǂݍ��ރt�@�C���̃p�X�@
target2 = path & "\input\02.����\" & accountingPeriodVlue & "��\" & yyyymm & "\��Ǖ���ʉғ��������z" & infilemonth & "��.xlsx" 
        
    '�t�@�C���̗L�� ��Ǖ���ғ��������f�[�^
     if fso.fileexists(target2) then

        'Excel�̃C���X�^���X�̐���
        set excelApp = createObject("Excel.Application")

        'Excel�t�@�C�����J��
        set wb2 = excelApp.workbooks.open(target2, ,true)
    else
        wscript.echo "�t�@�C�������݂��܂���"
        exit function
    end if

set ws2 = wb2.Worksheets("�v���W�F�N�g�ꗗ�\")

r = 9

    do    
        '�ŏI�s�̔���
        if ws2.cells(r,"A") = "" then Exit do  
        
            project_code = Trim(ws2.cells(r,"A"))                      '�v���W�F�N�g�R�[�h

            business_sector = getColFValue(project_code)                 '���ƕ�

            supervising_department = getColGValue(project_code)           '��Ǖ���

            labor_cost = ws2.cells(r,"C")                                 '�J����

            cost_total = ws2.cells(r,"C")                                  '�����v

            gross_profit = cost_total * -1                                 '�e���z

            gross_profit_margin =  getColOValue(cost_total)                '�e����


            if fso.fileexists(filename) then 

                'CSV�ɏo�͂���f�[�^
                file.writeline accountingPeriodVlue & ",""" & project_code & """,""" & ws2.cells(r,"B") & """,""-"",""" _
                    & yyyymm & """,""-"",""" & business_sector & """,""" & supervising_department & """," & 0 & "," & 0 & "," _ 
                    & labor_cost & "," & 0 & "," & 0 & "," & cost_total & "," & gross_profit & "," & gross_profit_margin & ",""" _ 
                    & "-"",""-"",""38300015"",""�Z�p���C�E�ғ�����""" 

            else
                wscript.echo "�t�@�C�������݂��܂���"
                exit function

            end if

        r = r + 1
    loop

wb2.close false
file.close 

end function


'�w��N�������[�v���鏈��
function outFileNumber(yyyymm, filename)
Dim yyyy
Dim mm
Dim ki
Dim arrMonth
Dim i

yyyy = left(yyyymm,4)
mm = right(yyyymm,2)

    if mm >= 10 then
        ki = yyyy - 1978
    else
        ki = yyyy - 1979
    end if

yyyy = 1978 + ki

'�w���v���̊J�n�N������I���N���̔z����쐬
arrMonth = Array(yyyy & "10", yyyy & "11", yyyy & "12", (yyyy+1) & "01", (yyyy+1) & "02", (yyyy+1) & "03", (yyyy+1) & "04", (yyyy+1) & "05", (yyyy+1) & "06", (yyyy+1) & "07", (yyyy+1) & "08", (yyyy+1) & "09")

    '�z��̃��X�g���w��N���܂Ń��[�v�ŉ�
    for i = 0 To UBound(arrMonth)
        call operatingReserves(arrMonth(i), filename)

        if arrMonth(i) = yyyymm then exit for
    next

end function


'�ғ��������F�u���ƕ��v�̐ݒ�
function getColFValue(projectcode)
 Dim retval

    select case projectcode
        case "38300015-00": retval = "ZZ"
        case "38300015-01": retval = "SD"
        case "38300015-02": retval = "IS"
        case "38300015-03": retval = "LCM"
        case "38300015-04": retval = "PA"
        case "38300015-05": retval = "SD1"
        case "38300015-06": retval = "SD2"
        case "38300015-07": retval = "SD3"
        case "38300015-08": retval = "SD4"
        case "38300015-09": retval = "IS1"
        case "38300015-10": retval = "IS2"
        case "38300015-11": retval = "IS3"   
        case "38300015-12": retval = "LCM" 
        case "38300015-13": retval = "PA1" 
        case "38300015-14": retval = "PA2" 
        case else: retval = "XX"
    end select
    
     getColFValue= retval

end function

'�ғ��������F�u��Ǖ���v�̐ݒ�
function getColGValue(projectcode)
 Dim retval

    select case projectcode
        case "38300015-00": retval = "ZZ"
        case "38300015-01": retval = "SD"
        case "38300015-02": retval = "IS"
        case "38300015-03": retval = "LCM"
        case "38300015-04": retval = "PA"
        case "38300015-05": retval = "SD"
        case "38300015-06": retval = "SD"
        case "38300015-07": retval = "SD"
        case "38300015-08": retval = "SD"
        case "38300015-09": retval = "IS"
        case "38300015-10": retval = "IS"
        case "38300015-11": retval = "IS"   
        case "38300015-12": retval = "LCM" 
        case "38300015-13": retval = "PA" 
        case "38300015-14": retval = "PA" 
        case else: retval = "XX"
    end select
    
    getColGValue = retval

end function

'�ғ��������F�u�e�����v�̐ݒ�
function getColOValue(costtotal)
Dim letval

    if costtotal >= 0 then
        letval = -100
    else
        letval = 0
    end if

getColOValue = letval

end function

' 
' �T�v�FCSV Load �pSQL�t�@�C������
' �����Ffilename/CSV�t�@�C����
' �ߒl�Fboolean/True:����AFalse:�ُ�
' ���l�F
'
function createSalesAchievementLoadDataFile(filename, ki)
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
  file.writeline "delete from sales_achievement where accounting_period = " & ki & ";"
  file.writeline "load data"
  file.writeline "infile '" & data_file & "'"
  file.writeline "into table sales_achievement"
  file.writeline "fields terminated by ','"
  file.writeline "enclosed by '""'"
  file.writeline "lines terminated by '\r\n'"
  file.writeline "ignore 1 rows"
  file.writeline "(@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20)"
  file.writeline "set created = now()"
  file.writeline ", updated = now()"
  file.writeline ", accounting_period=@1"
  file.writeline ", project_code=@2"
  file.writeline ", project_name=@3"
  file.writeline ", client_name=@4"
  file.writeline ", accounting_month=@5"
  file.writeline ", sales_department=@6"
  file.writeline ", business_sector=@7"
  file.writeline ", supervising_department=@8"
  file.writeline ", amount_of_sales=@9"
  file.writeline ", material_cost=@10"
  file.writeline ", labor_cost=@11"
  file.writeline ", outsourcing_cost=@12"
  file.writeline ", expenses=@13"
  file.writeline ", cost_total=@14"
  file.writeline ", gross_profit=@15"
  file.writeline ", gross_profit_margin=@16"
  file.writeline ", type_of_contract=@17"
  file.writeline ", kinds=@18"
  file.writeline ", project_parent_code=@19"
  file.writeline ", project_parent_name=@20;"
  file.close()
end Function

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


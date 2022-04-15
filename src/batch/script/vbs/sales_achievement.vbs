call main()

function main()

    '月次実績データの処理
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

    'コマンドライン引数の利用
    set objargs = wscript.arguments

    if objargs.count <> 2 then
        wscript.echo "コマンドライン引数を２つ指定してください"
        exit function
    end if

    'ファイルシステムオブジェクト生成
    set fso = createObject("Scripting.FileSystemObject")

    'パスの取得
    path = getEnv("BAT_ROOT_PATH")

    '会計期
    accountingPeriodVlue = getColAValue(objargs(1))

    '出力ファイルの生成
    sqlfilename = accountingPeriodVlue & "_" & objargs(1) & "_sales_achievement.csv"
    file_name = path & "\output\" & sqlfilename
    set file = fso.createTextFile(file_name, true)

    '一行目はタイトル名を出力
    file.writeline """accounting_period"",""project_code"",""project_name"",""client_name""," _
               & "accounting_month"",""sales_department"",""business_sector""," _
               & "supervising_department"",""amount_of_sales"",""material_cost"",""labor_cost""," _
               & "outsourcing_cost"",""expenses"",""cost_total"",""gross_profit""," _
               & "gross_profit_margin"",""type_of_contract"",""kinds"",""project_parent_code""," _
               & "project_parent_name"""

    '読み込むファイルの月
    infilemonth = getInfileMonth(objargs(1))

    '読み込むファイルのパス
    target = path & "\input\02.実績\" & accountingPeriodVlue & "期\" & objargs(1) & "\" & infilemonth & "月月次実績データ.xlsx"

    'ファイルの有無 月次実績データ
    if fso.fileexists(target) then
        'Excelのインスタンスの生成
        set excelApp = createObject("Excel.Application")

        'Excelファイルを開く
        set wb = excelApp.workbooks.open(target, ,true)
    else
        wscript.echo "ファイルが存在しません."
        exit function
    end if

    set ws = wb.Worksheets("月次実績データ")

    '最終行まで繰り返す
    for r = 2 to ws.cells(1,1).end(-4121).Row   

        'CSVに出力するデータ
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

    '稼動準備金データの処理
    call outFileNumber(objargs(1), file_name)

    'インポート用SQLファイル作成
    call createSalesAchievementLoadDataFile(sqlfilename, accountingPeriodVlue)

    wscript.echo "終了！！"

end function


'月次実績・稼動準備金：「会計期」の設定
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


'出力ファイルの「月」の設定
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


'出力ファイルの「実行日時」の設定
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


'月次実績：「計上月」の設定
function getColEValue(wsD,ki)
Dim yyyy
Dim mm
Dim letval

yyyy = ki + 1978
mm = replace(wsD,"月", "")

if mm >= 10  then
    letval = yyyy & mm
else
    letval = (yyyy + 1) & ("0" & mm)
end if

getColEValue = letval

end function



'稼動準備金データの処理
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


'ファイルシステムオブジェクト生成
set fso = createObject("Scripting.FileSystemObject")

'パスの取得
path = getEnv("BAT_ROOT_PATH")

'会計期
accountingPeriodVlue = getColAValue(yyyymm)    

'読み込むファイルの月
infilemonth = getInfileMonth(yyyymm)             

'出力ファイルへ追加
set file = fso.OpenTextFile(filename, 8)

'読み込むファイルのパス　
target2 = path & "\input\02.実績\" & accountingPeriodVlue & "期\" & yyyymm & "\主管部門別稼動準備金額" & infilemonth & "月.xlsx" 
        
    'ファイルの有無 主管部門稼動準備金データ
     if fso.fileexists(target2) then

        'Excelのインスタンスの生成
        set excelApp = createObject("Excel.Application")

        'Excelファイルを開く
        set wb2 = excelApp.workbooks.open(target2, ,true)
    else
        wscript.echo "ファイルが存在しません"
        exit function
    end if

set ws2 = wb2.Worksheets("プロジェクト一覧表")

r = 9

    do    
        '最終行の判定
        if ws2.cells(r,"A") = "" then Exit do  
        
            project_code = Trim(ws2.cells(r,"A"))                      'プロジェクトコード

            business_sector = getColFValue(project_code)                 '事業部

            supervising_department = getColGValue(project_code)           '主管部門

            labor_cost = ws2.cells(r,"C")                                 '労務費

            cost_total = ws2.cells(r,"C")                                  '原価計

            gross_profit = cost_total * -1                                 '粗利額

            gross_profit_margin =  getColOValue(cost_total)                '粗利率


            if fso.fileexists(filename) then 

                'CSVに出力するデータ
                file.writeline accountingPeriodVlue & ",""" & project_code & """,""" & ws2.cells(r,"B") & """,""-"",""" _
                    & yyyymm & """,""-"",""" & business_sector & """,""" & supervising_department & """," & 0 & "," & 0 & "," _ 
                    & labor_cost & "," & 0 & "," & 0 & "," & cost_total & "," & gross_profit & "," & gross_profit_margin & ",""" _ 
                    & "-"",""-"",""38300015"",""技術研修・稼動準備""" 

            else
                wscript.echo "ファイルが存在しません"
                exit function

            end if

        r = r + 1
    loop

wb2.close false
file.close 

end function


'指定年月をループする処理
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

'指定会計期の開始年月から終了年月の配列を作成
arrMonth = Array(yyyy & "10", yyyy & "11", yyyy & "12", (yyyy+1) & "01", (yyyy+1) & "02", (yyyy+1) & "03", (yyyy+1) & "04", (yyyy+1) & "05", (yyyy+1) & "06", (yyyy+1) & "07", (yyyy+1) & "08", (yyyy+1) & "09")

    '配列のリストを指定年月までループで回す
    for i = 0 To UBound(arrMonth)
        call operatingReserves(arrMonth(i), filename)

        if arrMonth(i) = yyyymm then exit for
    next

end function


'稼動準備金：「事業部」の設定
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

'稼動準備金：「主管部門」の設定
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

'稼動準備金：「粗利率」の設定
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
' 概要：CSV Load 用SQLファイル生成
' 引数：filename/CSVファイル名
' 戻値：boolean/True:正常、False:異常
' 備考：
'
function createSalesAchievementLoadDataFile(filename, ki)
  Dim fso
  Dim file
  Dim sql_file
  Dim data_file

  'ファイルシステムオブジェクト生成
  set fso = createObject("Scripting.FileSystemObject")

  '作成するSQLファイル名を生成
  sql_file = getEnv("BAT_ROOT_PATH") & getEnv("SQL_PATH") & getEnv("SQL_FILE_NAME")

  'インポートするCSVファイル名を生成
  data_file = getEnv("CONTAINER_LOAD_FILE_PATH") & filename

  '出力ファイル作成
  set file = fso.createTextFile(sql_file, true)

  'LOAD DATA 文の出力
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
' 概要：環境変数値を取得
' 引数：env_name/環境変数名(%なし)
' 戻値：string/環境変数値
' 備考：
'
function getEnv(env_name)
  Dim objShell
  
  'シェルオブジェクト作成
  Set objShell = CreateObject("WScript.Shell")
  
  '環境変数取得
  getEnv = objShell.ExpandEnvironmentStrings("%" & env_name & "%")
end Function


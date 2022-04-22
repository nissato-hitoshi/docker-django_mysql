call main()

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

' 
' 概要：CSV Load 用SQLファイル生成
' 引数：filename/CSVファイル名
' 戻値：boolean/True:正常、False:異常
' 備考：
'
function createSalesBudgetLoadDataFile(filename)
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

wscript.echo now() & ", 処理開始"

'ファイルシステムオブジェクト生成
set fso = createObject("Scripting.FileSystemObject")

'共通パスの生成
'path = fso.GetAbsolutePathName("C:\workspace\docker-django_mysql\src\batch")
'BAT ファイルにて環境変数を設定する仕様に変更
path = getEnv("BAT_ROOT_PATH")

'コマンドライン引数の取得
set objargs = wscript.arguments

if objargs.count <> 2 then
  wscript.echo "コマンドライン引数が正しく指定されていません"
  exit function
end if

'ファイルの有無
target = path & getEnv("INPUT_PATH") & objargs(0) & "期\" & objargs(0) & "期売上予算_営業資料.xlsm"

if fso.FileExists(target) then
  'Excelのインスタンスの生成
  set excelApp = CreateObject("Excel.Application")

  'Excel ファイルを開く
  set wb = excelApp.Workbooks.open(target, , true) 
else
  wscript.echo "ファイルが存在しません"
  exit function
end if

if objargs(1) = 1 then
  current_version = getCurVerupValue(objargs(0))
elseif objargs(1) = 2 then
  call UpSecHalfValue(objargs(0))
  current_version = getCurVerupValue(objargs(0))
end if

'出力ファイルを開く
'set file = fso.createTextFile(path & "\output\" & objargs(0) & "_sales_budget_" & format(now) & ".csv", true)

'出力ファイル名の生成
filename = objargs(0) & "_" & current_version & "_sales_budget.csv"

'LOAD DATA SQLファイルの生成
call createSalesBudgetLoadDataFile(filename)

'出力ファイル作成
set file = fso.createTextFile(path & getEnv("OUTPUT_PATH") & filename, true)

'タイトル行の出力
file.writeline """accounting_period"",""version"",""sales_department"",""classification"",""sales_representative"",""supervising_department"",""client_name"",""project_name"",""operator"",""accounting_month"",""sales_budget"",""sales_expected"",""sales_achievement"",""half_period"",""quarter"",""accuracy"""

'読み込む列番号の配列
cols = array(10, 12, 14, 16, 18, 20, 24, 26, 28, 30, 32, 34)

'ワークシートのループ
for each ws in wb.Worksheets

  if instr(ws.name, "実績") > 0 then

    wscript.echo now() & ", " & ws.name

    col_b = getColBValue(ws.name)
    col_c = getColCValue(ws.name)

    'ワークシート内のループ
    r = 5
    do

      '最終行の判定
      if ws.cells(r, "J") <> "" and ws.cells(r, "C") = "" and ws.cells(r, "F") = "" then Exit do

      '10月から9月(予算をループすると行が１増える）
      'for i = 0 to 11
      for i = 0 to ubound(cols)

        '予算、見込どちらにも値がない場合、そのデータは対象外
        if ws.cells(r, cols(i)) <> "" or ws.cells(r, cols(i) + 1) <> "" then

          years = getColIValue(objargs(0),i)             '年月

          halfyear = getColMValue(cols(i))               '半期

          quarter = getColNValue(cols(i))                '四半期

          if ws.cells(r,cols(i))= "" then                '予算
            budget = "0"
          else
            budget = ws.cells(r,cols(i)) 
          end if

          if ws.cells(r, cols(i) + 1) = "" then            '見込
            expected = "0"
          else
            expected = ws.cells(r, cols(i) + 1)
          end if

          if ws.cells(r,cols(i) + 1) <> "" then             '実績
            achievement = expected
          else
            achievement = budget
          end if

          accuracy = ws.cells(r, 41 + i)                   '確度（iの最小値は０）

          'CSVに出力するデータ
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

wscript.echo now() & ", CVS作成完了！！"

end function

function getColBValue(sheetname)
  Dim val
  Dim retval

  val = mid(sheetname,3,2)

  select case val
    case "第一": retval = "1:" & val
    case "第二": retval = "2:" & val
    case "ＢＳ": retval = "3:" & val
    case "ＳＩ": retval = "4:" & val
  end select

  getColBValue = retval

end function

function getColCValue(sheetname)
  Dim retval

  if instr(sheetname, "外注") > 0 then
    retval = "2:外注"
  elseif instr(sheetname, "物販") > 0 then
    retval = "3:物販"
  else
    retval = "1:社員"
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
    retval = "1:上期"
  case 24,26,28,30,32,34:
    retval = "2:下期"
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

'ADODB.Connectionオブジェクトを変数に格納。
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordsetオブジェクトを変数に格納。
Set rst = CreateObject("ADODB.Recordset")

'データベースとの接続
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'レコードセットのオープン（ SELECT の実行 ）
rst.Open strsql, con 'SQL文の実行

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


'メモリの解放（無くとも構わない）
rst.Close: Set rst = Nothing
con.Close: Set con = Nothing

end function

function getCurVerupValue(workbookname)

Dim con
Dim rst
Dim conStr
Dim strsql
Dim sql

'ADODB.Connectionオブジェクトを変数に格納。
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordsetオブジェクトを変数に格納。
Set rst = CreateObject("ADODB.Recordset")

'データベースとの接続
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'レコードセットのオープン（ SELECT の実行 ）
rst.Open strsql, con 'SQL文の実行

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


'メモリの解放（無くとも構わない）
rst.Close: Set rst = Nothing
con.Close: Set con = Nothing

end function

function UpSecHalfValue(workbookname)

Dim con
Dim rst
Dim conStr
Dim strsql
Dim sql

'ADODB.Connectionオブジェクトを変数に格納。
Set con = CreateObject("ADODB.Connection")

'ADODB.Recordsetオブジェクトを変数に格納。
Set rst = CreateObject("ADODB.Recordset")

'データベースとの接続
con.Open SqlCon()

strsql = "select * from version_control where accounting_period = " & workbookname & ""
'レコードセットのオープン（ SELECT の実行 ）
rst.Open strsql, con 'SQL文の実行

if rst.EOF then

  wscript.echo "レコードが存在しません"

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

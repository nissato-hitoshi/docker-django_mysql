
call sample1("202208")
call sample2(43, "202204")

'
' DateAdd関数を用いたサンプル
' target_month には 実績取込む年月(yyyymm形式）を指定
'
function sample1(target_month)
    dim current_month

    start_month = getStartMonth(target_month)

    current_month = start_month
    do 
        wscript.echo current_month
        if current_month = target_month then exit do
        current_month = addmonth(current_month)
    loop
end function

' 指定年月から会計期の開始年月を求める
function getStartMonth(target_month)
    dim yyyy 
    dim mm

    yyyy = left(target_month, 4)
    mm = right(target_month, 2)

    if mm >= "10" then
        getStartMonth = yyyy & "10"
    Else
        getStartMonth = (yyyy - 1) & "10"
    end if 
end function

' 年月加算処理
function addMonth(yyyymm)
    dim val
    val = Dateadd("m", 1, left(yyyymm, 4) & "/" & right(yyyymm, 2) & "/01")
    addmonth = Year(val) & right("0" & month(val), 2)
end Function

'
' 配列を用いたサンプル
' ki には 会計期を指定
' target_month には 実績取込む年月(yyyymm形式）を指定
'
function sample2(ki, target_month)
    Dim yyyy
    Dim i

    '会計期の開始年を求める
    yyyy = 1978 + ki

    '指定会計期の開始年月から終了年月の配列を作成
    arrMonth = Array(yyyy & "10", yyyy & "11", yyyy & "12", (yyyy+1) & "01", (yyyy+1) & "02", (yyyy+1) & "03", (yyyy+1) & "04", (yyyy+1) & "05", (yyyy+1) & "06", (yyyy+1) & "07", (yyyy+1) & "08", (yyyy+1) & "09")

    '配列のリストを指定年月までループで回す
    for i = 0 To UBound(arrMonth)
        wscript.echo arrMonth(i)
        if arrMonth(i) = target_month then exit for
    next
end function

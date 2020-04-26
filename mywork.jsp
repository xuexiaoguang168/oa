<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "com.redmoon.oa.worklog.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考勤</title>
<link href="common.css" rel="stylesheet" type="text/css">
<%@ include file="inc/nocache.jsp"%>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
//-->
</script>
<script language=javascript>
<!--
function openWin(url,width,height)
{
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=50,left=120,width="+width+",height="+height);
}
//-->
</script>
</head>
<body background="" leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<%
if (!privilege.isUserLogin(request))
{
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%!
  int daysInMonth[] = {
      31, 28, 31, 30, 31, 30, 31, 31,
      30, 31, 30, 31};

  public int getDays(int month, int year) {
    //测试选择的年份是否是润年？
    if (1 == month)
      return ( (0 == year % 4) && (0 != (year % 100))) ||
          (0 == year % 400) ? 29 : 28;
        else
      return daysInMonth[month];
  }
%>
<%
	// 翻月
	int showyear,showmonth;
	Calendar cal = Calendar.getInstance();
	int curday = cal.get(cal.DAY_OF_MONTH);
	int curhour = cal.get(cal.HOUR_OF_DAY);
	int curminute = cal.get(cal.MINUTE);
	int curmonth = cal.get(cal.MONTH);
	int curyear = cal.get(cal.YEAR);
	
	String strshowyear = request.getParameter("showyear");
	String strshowmonth = request.getParameter("showmonth");
	if (strshowyear!=null)
		showyear = Integer.parseInt(strshowyear);
	else
		showyear = cal.get(cal.YEAR);
	if (strshowmonth!=null)
		showmonth = Integer.parseInt(strshowmonth);
	else
		showmonth = cal.get(cal.MONTH)+1;
%>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe">
  <tr>
    <td width="100%" height="23" class="right-title">&nbsp;<span><%=showmonth%>月 工 作 记 事 表 </span></td>
  </tr>
  <tr>
    <td valign="top">
<%
String userName = ParamUtil.get(request, "userName");
if(userName.equals("")){
	userName = privilege.getUser(request);
}

String op = ParamUtil.get(request, "op");

if (op.equals("add"))
{
	boolean re = false;
	try {
		WorkLogMgr wlm = new WorkLogMgr();
		re = wlm.create(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re)
		out.print(StrUtil.Alert("操作成功！"));
}
%>
<table width="98%" border="0" align="center">
        <tr> 
          <td colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr> 
          <td width="52%" align="center">
		  <select name="showyear" onChange="var y = this.options[this.selectedIndex].value; window.location.href='?showyear=' + y;">
		  <%for (int y=curyear-60; y<=curyear; y++) {%>
		  <option value="<%=y%>"><%=y%></option>
		  <%}%>
		  </select>
		  <script>
		  showyear.value = "<%=showyear%>";
		  </script>
		  <%
for (int i=1; i<=12; i++) {
	if (showmonth==i)
		out.print("<a href='mywork.jsp?userName="+StrUtil.UrlEncode(userName)+"&showyear="+showyear+"&showmonth="+i+"'><font color=red>"+i+"月</font></a>&nbsp;");
	else
		out.print("<a href='mywork.jsp?userName="+StrUtil.UrlEncode(userName)+"&showyear="+showyear+"&showmonth="+i+"'>"+i+"月</a>&nbsp;");

}
%> 
		  <a href="mywork_list.jsp?userName=<%=StrUtil.UrlEncode(userName)%>">全部</a></td>
          <form method="post" action="mywork_list.jsp?op=search&userName=<%=StrUtil.UrlEncode(userName)%>">
          <td width="48%" align="center">搜索&nbsp;
          <input name="what" value="">
          &nbsp;
          <input type="submit" value="确定"></td>
</form>		  
        </tr>
      </table>
<%
String sql = "select id from work_log where MONTH(myDate)="+showmonth+" and YEAR(myDate)="+showyear+" and userName="+StrUtil.sqlstr(userName)+" order by myDate asc";

int i = 1;
String content="",mydate="",strweekday="";
int id = -1;
int weekday=0;
Date dt = null;
int monthday = -1;
int monthdaycount = getDays(showmonth-1,showyear);//当前显示月份的天数
String[] wday = {"","日","一","二","三","四","五","六"};
boolean rsnotend = true;
boolean coloralt = true;//背景颜色交替
String backcolor = "#ffffff";
Calendar cld = Calendar.getInstance();

WorkLogDb wld = new WorkLogDb();
Iterator ir = wld.list(sql).iterator();
%>
      <br>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" class="stable">
        <tr align="center" bgcolor="#C4DAFF"> 
          <td width="8%" class="stable">星期</td>
          <td width="13%" class="stable">日期</td>
          <td class="stable">内 容</td>
          <td width="29%" class="stable">记录时间</td>
        </tr>
      </table>
      <%
		if (ir.hasNext()) {
			wld = (WorkLogDb)ir.next();
			mydate = DateUtil.format(wld.getMyDate(), "yyyy-MM-dd HH:mm:ss");
			cld.setTime(wld.getMyDate());
			monthday = cld.get(cld.DAY_OF_MONTH);
		}
		while (i<=monthdaycount) {
			if (monthday==i) {
				coloralt = !coloralt;
				if (coloralt)
					backcolor = "#eeeeee";
				else
					backcolor = "#ECFFDF";
				String oldbackcolor = backcolor;
				
				backcolor = oldbackcolor;
				if (wld.isLoaded()) {
					id = wld.getId();
					content = wld.getContent();
					mydate = DateUtil.format(wld.getMyDate(), "yyyy-MM-dd HH:mm:ss");
					cld.setTime(wld.getMyDate());
					
					weekday = cld.get(cld.DAY_OF_WEEK);
					strweekday = wday[weekday];
				}
		%>
		<table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" class="stable">
        <tr align="center" bgcolor="<%=backcolor%>"> 
          <td width="8%" bgcolor="<%=backcolor%>" class="stable"><%=strweekday%> </td>
          <td width="13%" bgcolor="<%=backcolor%>" class="stable"><%=i%></td>
          <td align="left" bgcolor="<%=backcolor%>" class="stable"><a title="查看" href="mywork_show.jsp?id=<%=id%>&userName=<%=StrUtil.UrlEncode(userName)%>"><%=StrUtil.toHtml(content)%></a></td>
          <td width="29%" bgcolor="<%=backcolor%>" class="stable">
		  <%if (curyear==showyear && curmonth+1==showmonth && curday==i) { %>
		  <a title="修改" href="mywork_edit.jsp?id=<%=id%>&userName=<%=StrUtil.UrlEncode(userName)%>"><%=mydate%></a>
		  <%} else {%>
		  <%=mydate%>
		  <% } %>
		  </td>
        </tr>
        </table>
				<%
					if (ir.hasNext()) {
						wld = (WorkLogDb)ir.next();
						cld.setTime(wld.getMyDate());
						monthday = cld.get(cld.DAY_OF_MONTH);
					}
					else
						break;
			}
			else {
				cld.set(showyear,showmonth-1,i);
				weekday = cld.get(cld.DAY_OF_WEEK);
				strweekday = wday[weekday];
				if (weekday==1 || weekday==7) {
					strweekday = "<font color=red>"+strweekday+"</font>";	
				}			
				%>
	  <table width="98%" border="0" align="center" cellpadding="2" cellspacing="0" class="stable">
        <tr align="center"> 
          <td width="8%" class="stable"><%=strweekday%></td>
          <td width="13%" class="stable"><%=i%></td>
          <td class="stable">&nbsp;</td>
          <td width="29%" class="stable">&nbsp;</td>
        </tr>
      </table>
			<%
			}
			i++;
		}
%>
<br>
<%
	if (curyear==showyear && (curmonth+1)==showmonth) {
%>
      <table width="454" border="0" align="center" cellpadding="0" cellspacing="0" class="stable">
        <tr bgcolor="#C4DAFF"> 
          <td height="21" colspan="2" align="center" bgcolor="#C4DAFF" class="stable">今日记事</td>
        </tr>
        <form name="form1" action="?op=add" method="post" onSubmit="">
          <tr bgcolor="#EEEEEE"> 
            <td width="62" height="17" align="center" class="stable">内 容</td>
            <td width="390" height="17" class="stable"> <textarea name=content cols="50" class="singleboarder" rows="10"></textarea> 
            </td>
          </tr>
          <tr bgcolor="#EEEEEE"> 
            <td height="28" colspan="2" align="center" class="stable"> <input name="submit" type=submit value="确定"> 
            &nbsp;&nbsp;&nbsp; <input name="reset" type=reset value="取消">            </td>
          </tr>
        </form>
      </table> 
      <%
}
%>
    </td>
  </tr>
  <tr>
    <td height="9">&nbsp;</td>
  </tr>
</table>
</body>
</html>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "com.redmoon.oa.archive.*"%>
<%@ page import = "com.redmoon.oa.person.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "com.redmoon.oa.BasicDataMgr"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>考核添加</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function findObj(theObj, theDoc)
{
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

var GetDate=""; 
function SelectDate(ObjName,FormatDate){
	var PostAtt = new Array;
	PostAtt[0]= FormatDate;
	PostAtt[1]= findObj(ObjName);
	GetDate = showModalDialog("../util/calendar/calendar.htm", PostAtt ,"dialogWidth:286px;dialogHeight:221px;status:no;help:no;");
}

function SetDate()
{ 
	findObj(ObjName).value = GetDate; 
}

function chkContent(){
   if(form1.userName.value == ""){
     alert("用户名不能为空！")
	 form1.userName.focus();
	 return false
   }
}
function setPerson(deptCode, deptName, user, userRealName)
{
	form1.userName.value = user;
	form1.userRealName.value = userRealName;
}
//-->
</script>
<style type="text/css">
<!--
.style2 {font-size: 14px}
-->
</style>
</head>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
	String userName = ParamUtil.get(request,"userName");
	if (!privilege.isUserPrivValid(request, "archive.his")) {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
%>
<body background="" leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<%@ include file="archive_inc_his_menu_top.jsp"%>
<%
	String strId = ParamUtil.get(request, "id");
	if (!StrUtil.isNumeric(strId)) {
		out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.module.archive","warn_id_err_archive")));
		return;
	}
	int id = Integer.parseInt(strId);
	
	UserAssessHisDb uahd = new UserAssessHisDb();
	uahd = uahd.getUserAssessHisDb(id);
	
	UserInfoHisDb uihd = new UserInfoHisDb();
	String userRealName = uihd.getUserRealName(uahd.getUserName());	
	
	UserDb ud = new UserDb();
	ud = ud.getUserDb(uahd.getOperator());
	String operator = ud.getRealName();
	
	
%>
<br>
<table class="main" cellSpacing="1" cellPadding="2" width="600" align="center" border="0">
  <tbody>
    <tr>
      <td colspan="2" noWrap class="right-title">修改考核信息</td>
    </tr>
    <tr>
      <td class="TableContent" noWrap>用户名称：</td>
      <td class="TableData"><%=userRealName%></td>
    </tr>
    <tr>
      <td class="TableContent" noWrap>考核年度：</td>
      <td class="TableData"><%=uahd.getAssessYear()%></td>
    </tr>
    <tr>
      <td class="TableContent" noWrap>考核情况：</td>
      <td class="TableData"><%=uahd.getInfo()%></td>
    </tr>
    <tr>
      <td class="TableContent" noWrap>审批时间：</td>
      <td class="TableData"><%=uahd.getMyDate()%></td>
    </tr>
    <tr>
      <td class="TableContent" noWrap>考核结果：</td>
      <td class="TableData"><%=uahd.getResult()%></td>
    </tr>   
    <tr>
      <td class="TableContent" noWrap>备注：</td>
      <td class="TableData"><%=uahd.getRemark()%></td>
    </tr>
	<tr>
      <td class="TableContent" noWrap>操作人：</td>
      <td class="TableData"><%=operator%></td>
    </tr>
	<tr>
      <td class="TableContent" noWrap>操作类型：</td>
      <td class="TableData"><%=uahd.getOperateType()%></td>
    </tr>
	<tr>
      <td class="TableContent" noWrap>操作时间：</td>
      <td class="TableData"><%=uahd.getAddDate()%></td>
    </tr>
  </tbody>
</table>
</body>
</html>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "com.redmoon.oa.archive.*"%>
<%@ page import = "com.redmoon.oa.person.*"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>人事档案管理</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.style2 {font-size: 14px}
-->
</style>
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

function setPerson(deptCode, deptName, user, userRealName)
{
	form1.userName.value = user;
	form1.userRealName.value = userRealName;
}
//-->
</script>
</head>

<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<jsp:useBean id="archivePrivilege" scope="page" class="com.redmoon.oa.archive.ArchivePrivilege"/>
<% 
	String userName = ParamUtil.get(request,"userName");
	if (!privilege.isUserPrivValid(request, "archive.resume")||!archivePrivilege.canAdminUser(request,userName)) {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
%>
<%@ include file="archive_inc_menu_top.jsp"%>
<%	
	String strId = ParamUtil.get(request, "id");
	if (!StrUtil.isNumeric(strId)) {
		out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.module.archive","warn_id_err_archive")));
		return;
	}
	int id = Integer.parseInt(strId);
	
	UserResumeDb urd = new UserResumeDb();
	urd = urd.getUserResumeDb(id);
	
	UserInfoDb uid = new UserInfoDb();
	uid = uid.getUserInfoDb(userName);
	String userRealName = uid.getUserRealName();
%>
<br>
<table width="90%" border="0" align="center" cellPadding="2" cellSpacing="1" bgcolor="#FFFFFF" class="tableframe">
  <form name="form1" action="archive_resume_do.jsp?op=modify" method="post">
    <tbody>
	  <tr>
		<td colspan="3" class="right-title">修改履历信息</td>
	  </tr>
      <tr>
        <td width="80" noWrap>用&nbsp;&nbsp;户&nbsp;&nbsp;名：</td>
        <td colSpan="2"><input maxLength="100" name="userRealName" size="20" readonly value="<%=userRealName%>"><input name="userName" type="hidden" value="<%=userName%>">
          <input type="hidden" name="id" value="<%=id%>">
        </td>
      </tr>
      <tr>
        <td noWrap>单位名称：</td>
        <td colSpan="2"><input maxLength="100" name="company" size="20" value="<%=urd.getCompany()%>"></td>
      </tr>
      <tr>
        <td noWrap>担任工作：</td>
        <td colSpan="2"><input maxLength="100" name="job" size="20" value="<%=urd.getJob()%>"></td>
      </tr>
      <tr>
        <td noWrap>开始时间：</td>
        <td colSpan="2"><input maxLength="100" name="beginDate" size="20" value="<%=DateUtil.format(urd.getBeginDate(),"yyyy-MM")%>"><img style="CURSOR: hand" onClick="SelectDate('beginDate', 'yyyy-MM')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">  
          日期格式形如 1999-1-2</td>
      </tr>
      <tr>
        <td noWrap>结束时间：</td>
        <td colSpan="2"><input maxLength="100" name="endDate" size="20" value="<%=DateUtil.format(urd.getEndDate(),"yyyy-MM")%>"><img style="CURSOR: hand" onClick="SelectDate('endDate', 'yyyy-MM')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">  
          日期格式形如 1999-1-2</td>
      </tr>
      <tr>
        <td noWrap>离职原因：</td>
        <td colSpan="2"><input maxLength="100" name="leaveReason" size="20" value="<%=urd.getLeaveReason()%>"></td>  
      </tr>
      <tr>
        <td noWrap>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
        <td colSpan="2"><textarea name="remark" cols="45" rows="3" wrap="yes" class="BigINPUT" id="remark"><%=urd.getRemark()%></textarea></td>
      </tr>
      <tr>
        <td noWrap align="middle" colSpan="3"><input value="保存" type="submit">&nbsp;&nbsp; 
          <input type="reset" value="重填">&nbsp;&nbsp;</td>
      </tr>
    </tbody>
  </FORM>
</table>
</body>
</html>

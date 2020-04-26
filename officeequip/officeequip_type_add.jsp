<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "com.redmoon.oa.officeequip.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>办公类别添加</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<%@ include file="../inc/nocache.jsp"%>
<script language="JavaScript" type="text/JavaScript">
<!--

//-->
</script>
<style type="text/css">
<!--
.style2 {font-size: 14px}
.STYLE5 {color: #FF0000}
.STYLE6 {color: #000000}
-->
</style>
</head>
<body background="" leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
String priv="officeequip";
if (!privilege.isUserPrivValid(request, priv)) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	OfficeTypeMgr btm = new OfficeTypeMgr();
	boolean re = false;
	try {
		  re = btm.create(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re)
		//out.print(StrUtil.Alert_Redirect("操作成功！", "officeequip_type_list.jsp"));
		%>
	<script>
	window.opener.location.reload();
	window.close();
	</script>
<%}%>
<table width="100%" height="89" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="tableframe">
  <form id=form1 name="form1" action="?op=add" method=post>
    <td valign="top">
    <tr>
      <td width="100%" class="right-title">&nbsp;办公用品类别添加</td>
    </tr>
    <tr>
      <td height="26" align="left"><table width="368" border="0" align="left" cellpadding="3">
        <tr align="left">
          <td width="150"><span class="STYLE6">用品类别名称(<span class="STYLE5">*</span>)</span></td>
          <td width="202"><input name="name" width="200"></td>
        </tr>
        <tr align="left">
          <td>参考单位<span class="STYLE6">(<span class="STYLE5">*</span>)</span></td>
          <td><input name="unit" width="200"></td>
        </tr>
        <tr align="left">
          <td>备注</td>
          <td><input name="abstracts" width="200"></td>
        </tr>
      </table>
          
        <p>&nbsp;</p>
        <p align="center">&nbsp;
              <input name="submit" type=submit class="button1" value="提  交">
        </p>
        </span></td>
    </tr>
  </form>
</table>
</body>
</html>

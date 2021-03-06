<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.oa.pvg.*"%>
<%@ page import="com.redmoon.oa.person.*"%>
<%@ page import="cn.js.fan.web.*"%>
<html>
<head>
<title>管理角色权限</title>
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="privmgr" scope="page" class="com.redmoon.oa.pvg.PrivMgr"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	// out.println(StrUtil.makeErrMsg(privilege.MSG_INVALID,"red","green"));
	// return;
}
%>
<%
String roleCode = ParamUtil.get(request, "roleCode");
if (roleCode.equals("")) {
	out.print(StrUtil.makeErrMsg("角色编码不能为空！"));
	return;
}

String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("setrolepriv")) {
	com.redmoon.oa.pvg.Privilege privg = new com.redmoon.oa.pvg.Privilege();
	try {
		if (privg.setRolePriv(request))
			out.print(StrUtil.Alert("修改角色权限成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理角色权限</td>
    </tr>
  </tbody>
</table>
<%
RoleDb rd = new RoleDb();
String[] rolePriv = rd.getRolePriv(roleCode);

PrivDb[] privs = privmgr.getAllPriv();
String priv, desc;
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="77%" align="center">
   <form name="form1" method="post" action="?op=setrolepriv">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="15%">&nbsp;</td>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="32%">编码</td>
      <td class="thead" noWrap width="53%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">描述</td>
    </tr>
<%
int len = 0;
if (privs!=null)
	len = privs.length;
int privlen = 0;
if (rolePriv!=null)
	privlen = rolePriv.length;
	
for (int i=0; i<len; i++) {
	PrivDb pv = privs[i];
	priv = pv.getPriv();
	desc = pv.getDesc();
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">
	  <%
	  boolean isChecked = false;
	  for (int k=0; k<privlen; k++) {
	  	if (rolePriv[k].equals(priv)) {
			isChecked = true;
			break;
		}
	  }
	  if (isChecked)
	  	out.print("<input type=checkbox name=priv value='" + priv + "' checked>");
	  else
	  	out.print("<input type=checkbox name=priv value='" + priv + "'");
	  %>
	  </td>
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=priv%></td>
      <td><%=desc%></td>
    </tr>
<%}%>
    <tr align="center" class="row" style="BACKGROUND-COLOR: #ffffff">
      <td colspan="3" style="PADDING-LEFT: 10px">
	  <input type=hidden name=roleCode value="<%=roleCode%>">
	  <input name="Submit" type="submit" class="singleboarder" value="提交">
&nbsp;&nbsp;&nbsp;
<input name="Submit" type="reset" class="singleboarder" value="重置"></td>
    </tr>
  </tbody></form>
</table>
<HR noShade SIZE=1>
<DIV style="WIDTH: 95%" align=right></DIV>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "密码与确认密码不致，请检查！\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>
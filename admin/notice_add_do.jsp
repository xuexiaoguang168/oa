<%@ page contentType="text/html;charset=gb2312"
import = "java.io.File"
import = "fan.util.*"
%>
<html>
<head>
<title>发件箱</title>
<%@ include file="../inc/nocache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" href="../common.css" type="text/css">
<script language="javascript">
<!--
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%@ include file="../inc/inc.jsp"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<jsp:setProperty name="privilege" property="defaulturl" value="../index.jsp"/>
<!--重定向至 :<jsp:getProperty name="privilege" property="defaulturl"   />-->
<%
		String priv="admin";
		String priv1="notice_public";
		if (!privilege.isUserPrivValid(request,priv) && !privilege.isUserDepartmentPrivValid(request,priv1))
		{
			out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
			return;
		}
%>
<jsp:useBean id="notice" scope="page" class="com.redmoon.oa.Notice"/>
<%
boolean re = false;
try {
	re = notice.Write(request);
}
catch (ErrMsgException e) {
	out.println(e.getMessage());
}
if (re)
	out.println(fchar.Alert_Back("发送通知成功！"));
%>
</body>
</html>



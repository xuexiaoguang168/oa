<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "com.redmoon.oa.meeting.*"%>
<html>
<head>
<title>修改会议室</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../admin/default.css" type="text/css">
<script language=javascript>
<!--
function openWin(url,width,height)
{
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=50,left=120,width="+width+",height="+height);
}
//-->
</script>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="5">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "meetingroom")) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
int id = ParamUtil.getInt(request, "id");
BoardroomDb bd = new BoardroomDb();
bd = bd.getBoardroomDb(id);
if (bd==null || !bd.isLoaded()) {
	out.print(StrUtil.Alert_Back("该会议室不存在！"));
	return;
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
    <TR>
      <TD class=head>会议室管理</TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<br>
<table width="49%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="center" class="thead style1">修改会议室</td>
  </tr>
  <tr>
    <td valign="top"><table width="93%" border="0" align="center" cellpadding="0" cellspacing="0" class="stable">
      
      <form name="form1" action="boardroom_do.jsp?op=edit" method="post" onSubmit="">
        <tr>
          <td width="14%" height="24" align="center" class="stable">名&nbsp;&nbsp;称</td>
          <td width="86%" height="19" class="stable"><input type="text" name="name" class="singleboarder" size=50 value="<%=bd.getName()%>">
		  <input type="hidden" name="id" value="<%=id%>">
		  </td>
        </tr>
        <tr>
          <td height="24" align="center" class="stable">人&nbsp;&nbsp;数</td>
          <td height="20" class="stable"><input type="text" class="singleboarder" name="personNum" size=15 value="<%=bd.getPersonNum()%>"></td>
        </tr>
        <tr>
          <td height="24" align="center" class="stable">位&nbsp;&nbsp;置</td>
          <td height="20" class="stable"><input type="text" class="singleboarder" name="address" size=50 value="<%=bd.getAddress()%>"></td>
        </tr>
        <tr>
          <td height="24" align="center" class="stable">设&nbsp;&nbsp;备</td>
          <td height="20" class="stable">
              <input type="text" class="singleboarder" name="equipment" size=50 value="<%=bd.getEquipment()%>">
          </td>
        </tr>
        <tr>
          <td height="17" align="center" class="stable">说&nbsp;&nbsp;明</td>
          <td height="17" class="stable"><textarea name="description" cols="60" class="singleboarder" rows="10"><%=bd.getDescription()%></textarea>          </td>
        </tr>
        <tr>
          <td colspan="2" align="center">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input name="submit" type="submit" class="singleboarder" value="确定">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input name="reset" type="reset" class="singleboarder" value="重填">          </td>
          </tr>
        <tr>
          <td colspan="2" align="center">&nbsp;</td>
        </tr>
      </form>
    </table></td>
  </tr>
</table>
</body>
</html>
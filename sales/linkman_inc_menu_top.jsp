<%@ page contentType="text/html; charset=utf-8"%>
<script src="../inc/nav.js"></script>
<%
String action_inc = ParamUtil.get(request, "action");
%>
<table width="100%" height="30" border="1" align="center" cellpadding="1" cellspacing="0" borderColorLight="#848284" borderColorDark="#ffffff" bgcolor="D6D3CE" style="color:#ffffff">
  <tr>
    <td nowrap="nowrap"><table align="left" border="0" cellpadding="0" cellspacing="0" width="120" bgcolor="D6D3CE" style="color:#ffffff" onmouseover="return menu_table_onmouseover(this)" onmouseout="return menu_table_onmouseout(this)">
      <tr>
        <td width="35%" height="22" align="center" nowrap="nowrap" style="border:thin" onmouseover="return menu_td_onmouseover(this)" onmouseout="return menu_td_onmouseout(this)"><a class="black" href="linkman_list.jsp?action=<%=StrUtil.UrlEncode(action_inc)%>">联系人管理</a></td>
      </tr>
    </table>
      <table align="left" border="0" cellpadding="0" cellspacing="0" width="120" bgcolor="D6D3CE" style="color:#ffffff" onmouseover="return menu_table_onmouseover(this)" onmouseout="return menu_table_onmouseout(this)">
        <tr>
          <td width="35%" height="22" align="center" nowrap="nowrap" style="border:thin" onmouseover="return menu_td_onmouseover(this)" onmouseout="return menu_td_onmouseout(this)"><a class="black" href="linkman_add.jsp?formCode=sales_linkman">添加联系人</a></td>
        </tr>
      </table>
      <table align="left" border="0" cellpadding="0" cellspacing="0" width="120" bgcolor="D6D3CE" style="color:#ffffff" onmouseover="return menu_table_onmouseover(this)" onmouseout="return menu_table_onmouseout(this)">
      <tr>
        <td width="35%" height="22" align="center" nowrap="nowrap" style="border:thin" onmouseover="return menu_td_onmouseover(this)" onmouseout="return menu_td_onmouseout(this)"><a href="linkman_query.jsp?formCode=sales_linkman&action=<%=StrUtil.UrlEncode(action_inc)%>" class="black">高级查询</a></td>
      </tr>
    </table>
    </td>
  </tr>
</table>

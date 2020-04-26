﻿<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.oa.netdisk.*" %>
<%@ page import="com.redmoon.oa.pvg.*" %>
<html>
<head>
<title>文件列表</title>
<link href="../common.css" rel="stylesheet" type="text/css">
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
<jsp:useBean id="docmanager" scope="page" class="com.redmoon.oa.netdisk.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.oa.netdisk.Directory"/>
<%
//if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
//{
//	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
//	return;
//}
%>
<%
String sql = "select class1,title,id,isHome,examine from document";
String op = StrUtil.getNullString(request.getParameter("op"));
String dir_code = ParamUtil.get(request, "dir_code");
Leaf leaf = dir.getLeaf(dir_code);
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	try {
		if (docmanager.del(request, id, privilege))
			out.print(StrUtil.Alert("删除成功！"));
		else
			out.print(StrUtil.Alert("删除失败！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	op = "";
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">&nbsp;
      <%
	  if (!op.equals("search")) {
	  	if (leaf!=null && leaf.isLoaded()) {
			Leaf lf = leaf;
			String navstr = "";
			String parentcode = lf.getParentCode();
			Leaf plf = new Leaf();
			while (!parentcode.equals("root")) {
				plf = plf.getLeaf(parentcode);
				if (plf==null || !plf.isLoaded())
					break;
				if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()!=0)
					navstr = "<a href='dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()==0)
					navstr = "<a href='document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else
					navstr = plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				
				parentcode = plf.getParentCode();
			}
			out.print(navstr + lf.getName());
		}
	}
	else
		out.print("搜索结果");
		%></td>
    </tr>
  </tbody>
</table>
<%
String what = "";
if (op.equals("search")) {
	what = StrUtil.UnicodeToUTF8(StrUtil.getNullString(request.getParameter("what")));
	sql += " where title like "+StrUtil.sqlstr("%"+what+"%"); 
}
else {
	if (!dir_code.equals(""))
		sql += " where class1=" + StrUtil.sqlstr(dir_code);
}
sql += " order by examine asc, isHome desc, modifiedDate desc";
String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg("标识非法！"));
	return;
}
int pagesize = 15;
int curpage = Integer.parseInt(strcurpage);
PageConn pageconn = new PageConn(Global.defaultDB, Integer.parseInt(strcurpage), pagesize);
ResultIterator ri = pageconn.getResultIterator(sql);
ResultRecord rr = null;

Paginator paginator = new Paginator(request, pageconn.getTotal(), pagesize);
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<br>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
  <form name="form1" action="document_list_m.jsp?op=search" method="post">
    <tr>
      <td align="center">搜索文章标题&nbsp;
          <input name=what class="singleboarder" size=20>
          <input type=submit class="singleboarder" value="搜索">
      (输入关键字搜索)</td>
    </tr>
  </form>
</table>
<br>
<table width="92%" border="0" align="center" class="p9">
  <tr>
    <td height="24" align="right">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="11%">首页</td>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="39%">标题</td>
      <td class="thead" noWrap width="20%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">类型</td>
      <td class="thead" noWrap width="10%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">审核状态</td>
      <td class="thead" noWrap width="20%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">管理</td>
    </tr>
    <%
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next(); 
	boolean isHome = rr.getBoolean("isHome");
	%>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px"><input type="checkbox" name="isHome" <%=isHome?"checked":""%> onClick="location.href='doc_op.jsp?op=isHome&id=<%=rr.getString("id")%>&value=<%=isHome?"n":"y"%>'">
      <%=rr.getInt("id")%></td>
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="../fwebedit.jsp?op=edit&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode((String)rr.get(1))%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>"><%=(String)rr.get(2)%></a></td>
      <td><%=rr.getString("class1")%></td>
      <td>
	  <%
	  int examine = rr.getInt("examine");
	  if (examine==0)
	  	out.print("<font color='blue'>未审核</font>");
	  else if (examine==1)
	  	out.print("<font color='red'>未通过</font>");
	  else
	  	out.print("已通过");
	  %>
	  </td>
      <td><a href="../fwebedit.jsp?op=edit&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode((String)rr.get(1))%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[ 编辑 ]</a> <a onClick="return confirm('您确定要删除吗？')" href="document_list_m.jsp?op=del&id=<%=rr.getString(3)%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[ 删除 ]</a> <a href="../doc_show.jsp?id=<%=rr.getInt("id")%>">[ 查看 ]</a> </td>
    </tr>
    <%}%>
  </tbody>
</table>
<table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="right">&nbsp;</td>
  </tr>
  <tr>
    <td align="right"><%
	String querystr = "op="+op+"&what="+StrUtil.UrlEncode(what) + "&dir_code=" + StrUtil.UrlEncode(dir_code);
    out.print(paginator.getCurPageBlock("document_list_m.jsp?"+querystr));
%></td>
  </tr>
</table>
<HR noShade SIZE=1>
<%if (!dir_code.equals("") && leaf.getType()==2) {%>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='../fwebedit.jsp?op=add&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name, "utf-8")%>';" type=image 
height=20 width=80 src="images/btn_add.gif">
</DIV>
<%}%>
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
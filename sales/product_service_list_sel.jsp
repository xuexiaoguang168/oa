<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.db.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "com.redmoon.oa.visual.*"%>
<%@ page import = "com.redmoon.oa.flow.FormDb"%>
<%@ page import = "com.redmoon.oa.flow.FormField"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
String priv = "read";
if (!privilege.isUserPrivValid(request, priv))
{
	// out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	// return;
}

String op = ParamUtil.get(request, "op");
String formCode = "sales_product_service";

String querystr = "";

FormDb fd = new FormDb();
fd = fd.getFormDb(formCode);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=fd.getName()%>列表</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<%@ include file="../inc/nocache.jsp"%>
<script src="<%=Global.getRootPath()%>/inc/flow_dispose_js.jsp"></script>
<script src="<%=Global.getRootPath()%>/inc/flow_js.jsp"></script>
<script>
function sel(sth) {
	window.opener.setIntpuObjValue(sth);
	window.close();
}
</script>
</head>
<body background="" leftmargin="0" topmargin="5" marginwidth="0" marginheight="0">
<%@ include file="product_service_inc_menu_top.jsp"%>
<%
String sql = "select id from " + fd.getTableNameByForm();		

String query = ParamUtil.get(request, "query");
if (!query.equals(""))
	sql = query;
else
	if (op.equals("search")) {
		Iterator ir = fd.getFields().iterator();
		String cond = "";
		while (ir.hasNext()) {
			FormField ff = (FormField)ir.next();
			String value = ParamUtil.get(request, ff.getName());
			String name_cond = ParamUtil.get(request, ff.getName() + "_cond");
			if (ff.getType().equals(ff.TYPE_DATE) || ff.getType().equals(ff.TYPE_DATE_TIME)) {
				String fDate = ParamUtil.get(request, ff.getName() + "FromDate");
				String tDate = ParamUtil.get(request, ff.getName() + "ToDate");
				if (!fDate.equals("")) {
					if (cond.equals(""))
						cond += ff.getName() + ">=" + StrUtil.sqlstr(fDate);
					else
						cond += " and " + ff.getName() + ">=" + StrUtil.sqlstr(fDate);
				}
				if (!tDate.equals("")) {
					if (cond.equals(""))
						cond += ff.getName() + "<=" + StrUtil.sqlstr(tDate);
					else
						cond += " and " + ff.getName() + "<=" + StrUtil.sqlstr(tDate);
				}
			}
			else {
				if (name_cond.equals("0")) {
					if (!value.equals("")) {
						if (cond.equals(""))
							cond += ff.getName() + " like " + StrUtil.sqlstr("%" + value + "%");
						else
							cond += " and " + ff.getName() + " like " + StrUtil.sqlstr("%" + value + "%");
					}
				}
				else if (name_cond.equals("1")) {
					if (!value.equals("")) {
						if (cond.equals(""))
							cond += ff.getName() + "=" + StrUtil.sqlstr(value);
						else
							cond += " and " + ff.getName() + "=" + StrUtil.sqlstr(value);
					}
				}
			}
		}
		if (!cond.equals(""))
			sql = sql + " where " + cond;	
	}
querystr = "query=" + StrUtil.UrlEncode(sql);
%>

<table width="58%" border="0" align="center" cellSpacing="1" class="tableframe">
  <form id="form2" name="form2" action="?op=search" method="post">
    <tbody>
      <tr>
        <td noWrap colSpan="3">
          <table cellSpacing="0" cellPadding="0" width="100%" border="0">
            <tbody>
              <tr>
                <td colSpan="3" bgcolor="#C4DAFF"><b>服务型产品查询</b></td>
              </tr>
              <tr>
                <td width="29%">服务提供商：</td>
                <td noWrap width="19%"><select name="provider_cond">
                  <option value="1">等于</option>
                  <option value="0" selected>包含</option>
                </select></td>
                <td width="52%"><input name="provider" size="20"></td>
              </tr>
              <tr>
                <td width="29%">服务名称：</td>
                <td noWrap width="19%"><select name="service_name_cond">
                    <option value="1">等于</option>
                    <option value="0" selected>包含</option>
                  </select></td>
                <td width="52%"><input name="service_name" size="20"></td>
              </tr>
              <tr>
                <td width="29%">服务收费标准：</td>
                <td noWrap width="19%"><select name="standad_name_cond">
                    <option value="1">等于</option>
                    <option value="0" selected>包含</option>
                  </select></td>
                <td width="52%"><input name="standad_name" size="20"></td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
      <tr align="middle">
        <td noWrap align="middle" colSpan="3" height="35"><input class="BigButton"  type="submit" value="查  询" name="submit"> 
          &nbsp;&nbsp;&nbsp;&nbsp;</td>
      </tr>
    </tbody>
  </form>
</table>

<br>
<table width="494" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
  <tr> 
    <td height="23" valign="middle" class="right-title">&nbsp;<%=fd.getName()%></td>
  </tr>
  <tr> 
    <td valign="top" background="workplan/images/tab-b-back.gif">
<%
		int pagesize = 10;
		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
			
		FormDAO fdao = new FormDAO();
		
		ListResult lr = fdao.listResult(formCode, sql, curpage, pagesize);
		int total = lr.getTotal();
		Vector v = lr.getResult();
	    Iterator ir = null;
		if (v!=null)
			ir = v.iterator();
		paginator.init(total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
%>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="47">&nbsp;</td>
          <td align="right" backgroun="images/title1-back.gif">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=curpage %>/<%=totalpages %></td>
        </tr>
      </table> 
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1">
        <tr align="center" bgcolor="#C4DAFF"> 
          <td width="26%" bgcolor="#C4DAFF">服务产品名称</td>
          <td width="20%" bgcolor="#C4DAFF">收费标准</td>
          <td width="17%" bgcolor="#C4DAFF">操作</td>
        </tr>
      <%	
	  	int i = 0;
		while (ir!=null && ir.hasNext()) {
			fdao = (FormDAO)ir.next();
			i++;
			int id = fdao.getId();
		%>
        <tr align="center" bgcolor="#EEEEEE"> 
          <td width="26%" bgcolor="#EEEEEE"> <a href="product_service_show.jsp?id=<%=id%>&formCode=<%=formCode%>"><%=fdao.getFieldValue("service_name")%></a></td>
          <td width="20%" bgcolor="#EEEEEE"><%=fdao.getFieldValue("standad_name")%></td>
          <td width="17%" bgcolor="#EEEEEE">&nbsp;&nbsp;<a href="javascript:sel('<%=fdao.getFieldValue("service_name")%>')">选择</a>&nbsp;&nbsp;		  </td>
        </tr>
      <%
		}
%>
      </table>
      <br>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr> 
          <td width="1%" height="23">&nbsp;</td>
          <td height="23" valign="baseline"> 
            <div align="right"> 
            <%
			out.print(paginator.getCurPageBlock("?"+querystr));
			%>
              &nbsp;</div></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td height="9">&nbsp;</td>
  </tr>
</table>
</body>
</html>

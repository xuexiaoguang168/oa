<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import = "java.net.URLEncoder"%>
<%@ page import = "java.util.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "com.redmoon.oa.archive.*"%>
<%@ page import = "com.redmoon.oa.BasicDataMgr"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户档案查询</title>
<%@ include file="../inc/nocache.jsp"%>
<link href="../common.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
function selDate(name,condition){ 
   if(name.all.item(condition).value == "1"){
      name.all.item("SEGMENT_DATE_TD").style.display = "none";
      name.all.item("POINT_DATE_TD").style.display = "";	
	  name.all.item("VAGUE_SEGMENT_YEAR_TD").style.display = "none";
	  name.all.item("VAGUE_POINT_YEAR_TD").style.display = "none";  
   }else{
      if(name.all.item(condition).value == "2"){
		  name.all.item("SEGMENT_DATE_TD").style.display = "none";
		  name.all.item("POINT_DATE_TD").style.display = "none";	
		  name.all.item("VAGUE_SEGMENT_YEAR_TD").style.display = "";
		  name.all.item("VAGUE_POINT_YEAR_TD").style.display = "none";
	  }else{
		  if(name.all.item(condition).value == "3"){
			  name.all.item("SEGMENT_DATE_TD").style.display = "none";
			  name.all.item("POINT_DATE_TD").style.display = "none";	
			  name.all.item("VAGUE_SEGMENT_YEAR_TD").style.display = "none";
			  name.all.item("VAGUE_POINT_YEAR_TD").style.display = "";
		  }else{
			  name.all.item("SEGMENT_DATE_TD").style.display = "";
			  name.all.item("POINT_DATE_TD").style.display = "none";	
			  name.all.item("VAGUE_SEGMENT_YEAR_TD").style.display = "none";
			  name.all.item("VAGUE_POINT_YEAR_TD").style.display = "none";
		  }
	  }
   }
}

function addORConditionSel(btnObj,name){ 
    var text = "&nbsp;或者&nbsp;<select name='" + name + "'>" + maintable.all.item(name + "_OPTION").value + "</select>";
	btnObj.insertAdjacentHTML("BeforeBegin", text);
}

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
</script>
</head>

<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.oa.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "archive.query")) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
  <table width="95%" border="0">
  <form name="form1" method="post" action="archive_query_ordercode.jsp">
    <tr>
      <td>
<%
	String deptCodeStr = ParamUtil.get(request,"deptCodeStr");
	if(deptCodeStr.equals("")){
	   out.print(StrUtil.Alert_Back("请选择查询部门！"));
	   return;
	}

	String tableCodeStr = ParamUtil.get(request,"tableCodeStr");
    if(tableCodeStr.equals("")){
	   out.print(StrUtil.Alert_Back("请选择查询范围！"));
	   return;
	}
	
	String tableFullCodeStr = ParamUtil.get(request,"tableFullCodeStr");
	String showFieldCodeStr = ParamUtil.get(request,"showFieldCodeStr");
	
	String[] fieldFullCodeArr = ParamUtil.getParameters(request,"fieldFullCode");
    if(fieldFullCodeArr == null){
	   out.print(StrUtil.Alert_Back("请选择查询条件！"));
	   return;
	}
	
	String[] FieldCodeArr = null;
	String options = "",conditionFieldCodeStr = "",sql = "",fieldCode = "",tableShortCode = "";   
	
	//获得条件字段
	int i = 0 ;
	while(i < fieldFullCodeArr.length){
		conditionFieldCodeStr += fieldFullCodeArr[i];
		if(i < fieldFullCodeArr.length - 1){
		   conditionFieldCodeStr += ",";
		}
		i++;
	}
%>
      <table class="tableframe" cellSpacing="0" cellPadding="2" width="95%" align="center" border="0" bgcolor="#FFFFFF" id="maintable">
        <tbody>
          <tr>
            <td colspan="3" class="right-title">&nbsp;设置查询条件</td>
          </tr>
<%   	
	int j = 0;
	BasicDataMgr bdm = new BasicDataMgr("archive");
	TableFieldInfoDb tfid = new TableFieldInfoDb(); 

	while(j < fieldFullCodeArr.length){
	   FieldCodeArr = fieldFullCodeArr[j].split("\\."); 
	   tableShortCode = FieldCodeArr[0];
	   fieldCode = FieldCodeArr[1]; 
	   sql = ArchiveSQLBuilder.getArchiveTableField(tableShortCode,fieldCode);	      
	   Vector vt = tfid.list(sql);
	   Iterator ir = null;
	   ir = vt.iterator();
	   if (ir!=null && ir.hasNext()) {
		   tfid = (TableFieldInfoDb)ir.next();	
		   	   	   
           //处理文本字段
           if(Integer.parseInt(tfid.getFieldType()) == tfid.INPUT){
%>
          <tr>
            <td width="16%" noWrap><%=tfid.getFieldName()%>：</td>         
			<td width="84%" noWrap>
              <table width="100%">
			    <tr>
				  <td>
					<select name="<%=tableShortCode%>_<%=fieldCode%>_SIGN">
					  <option value="=">等于</option>
					  <option value="like" selected>包含</option>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="<%=tableShortCode%>_<%=fieldCode%>" size="20"/>
				  </td>
				 </tr>
			   </table>
			 </td>
          </tr>
<%		   
		   }
		   
		   //处理列表字段
		   if(Integer.parseInt(tfid.getFieldType()) == tfid.SELECTED){
			  options = bdm.getOptionsStr(fieldCode);
%>
          <tr>
            <td width="16%" noWrap><%=tfid.getFieldName()%>：</td>         
			<td width="84%" noWrap>
              <table width="100%">
			   <tr>
			    <td>			  
				  <input type="hidden" value="<%=options%>" name="<%=tableShortCode%>_<%=fieldCode%>_OPTION">	
				  <select name="<%=tableShortCode%>_<%=fieldCode%>">
					 <%=options%>
				  </select>		  
				  <input type="button" onClick='addORConditionSel(this,"<%=tableShortCode%>_<%=fieldCode%>")' value="添加或条件">
			    </td>
			   </tr>
			  </table>
			 </td>
          </tr>
<%			   
		   }		   
		   //处理日期字段
		   if(Integer.parseInt(tfid.getFieldType()) == tfid.SELEDATE){
%>
          <tr>
            <td width="16%" noWrap><%=tfid.getFieldName()%>：</td>         
			<td width="84%" noWrap>
			 <table id="<%=tableShortCode%>_<%=fieldCode%>_TABLE" width="100%">
			   <tr>
				<td width="14%">
					<select name="<%=tableShortCode%>_<%=fieldCode%>_COND" onChange="selDate(<%=tableShortCode%>_<%=fieldCode%>_TABLE,'<%=tableShortCode%>_<%=fieldCode%>_COND')">
						<option value="0" selected>精确段时间</option>
						<option value="1">精确点时间</option>
						<option value="2">模糊段时间</option>
						<option value="3">模糊点时间</option>
					</select>				
				</td>
				<td width="70%" align="left" id="SEGMENT_DATE_TD">
					从 
					  <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_FROMDATE" readonly><img style="CURSOR: hand" onClick="SelectDate('<%=tableShortCode%>_<%=fieldCode%>_FROMDATE', 'yyyy-MM-dd')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">
					至 <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_TODATE" readonly><img style="CURSOR: hand" onClick="SelectDate('<%=tableShortCode%>_<%=fieldCode%>_TODATE', 'yyyy-MM-dd')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">	
				</td>
				<td width="70%" align="left" id="POINT_DATE_TD" style="display:none">
					<select name="<%=tableShortCode%>_<%=fieldCode%>_SIGN">
						<option value="=" selected>等于</option>
						<option value=">">大于</option>
						<option value="<">小于</option>
						<option value="<=">小于等于</option>
						<option value=">=">大于等于</option>
					</select>
					&nbsp;&nbsp;<input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_DATE" readonly><img style="CURSOR: hand" onClick="SelectDate('<%=tableShortCode%>_<%=fieldCode%>', 'yyyy-MM-dd')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">
				</td>
			    <td width="70%" align="left" id="VAGUE_SEGMENT_YEAR_TD" style="display:none">截止至
			      <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_REFERENCE_SEGMENT_YEAR" readonly><img style="CURSOR: hand" onClick="SelectDate('<%=tableShortCode%>_<%=fieldCode%>_REFERENCE_SEGMENT_YEAR', 'yyyy')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">
					从 <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_FROMYEAR">
					至 <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_TOYEAR">(周岁或年)
				</td>
				<td width="70%" align="left" id="VAGUE_POINT_YEAR_TD" style="display:none">截止至
				  <input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_REFERENCE_POINT_YEAR" readonly><img style="CURSOR: hand" onClick="SelectDate('<%=tableShortCode%>_<%=fieldCode%>_REFERENCE_POINT_YEAR', 'yyyy')" src="../images/form/calendar.gif" align="absMiddle" border="0" width="26" height="26">
				  <select name="<%=tableShortCode%>_<%=fieldCode%>_VAGUE_SIGN">
				    <option value="=" selected>等于</option>
				    <option value=">">大于</option>
				    <option value="<">小于</option>
				    <option value="<=">小于等于</option>
				    <option value=">=">大于等于</option>
				    </select>
				  &nbsp;&nbsp;<input size="10" name="<%=tableShortCode%>_<%=fieldCode%>_YEAR">
				  (周岁或年)				  </td>
			   </tr>
			 </table>
			</td>
          </tr>		  
<%			   
		   }
       }
	   j++;
	}   
%>
        </tbody>
      </table>
      </td>
    </tr>  
    <tr>
      <td align="center"><input value="下一步 &#8594; 选择查询结果中用来排序的字段" type="submit">
        <input type="hidden" name="tableFullCodeStr" value="<%=tableFullCodeStr%>">
        <input type="hidden" name="tableCodeStr" value="<%=tableCodeStr%>"> 
        <input type="hidden" name="showFieldCodeStr" value="<%=showFieldCodeStr%>"> 
		<input type="hidden" name="conditionFieldCodeStr" value="<%=conditionFieldCodeStr%>"> 
		<input type="hidden" name="deptCodeStr" value="<%=deptCodeStr%>">
		&nbsp;&nbsp;    </td>
    </tr>
</form>
  </table>
</body>
</html>

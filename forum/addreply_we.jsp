<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
String targeturl = StrUtil.getUrl(request);
if (!privilege.isUserLogin(request)) {
	response.sendRedirect("../door.jsp?targeturl="+targeturl);
	return;
}

int i=0;
String replyid = request.getParameter("replyid");
if (replyid==null || !StrUtil.isNumeric(replyid))
{
	out.println(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.ERR_ID)));
	return;
}
MsgMgr msgMgr = new MsgMgr();
MsgDb msgDb = msgMgr.getMsgDb(Integer.parseInt(replyid));
String boardcode = msgDb.getboardcode();

String userName = privilege.getUser(request);
if (!privilege.canUserDo(request, boardcode, "reply_topic")) {
	response.sendRedirect("../info.jsp?info= " + StrUtil.UrlEncode(SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String privurl = request.getParameter("privurl");
String quote = StrUtil.getNullString(request.getParameter("quote"));
String quotecontent = "";
String retopic;

retopic = msgDb.getTitle();
String qc = SkinUtil.LoadString(request, "res.label.forum.addreply", "quote_content");
qc = qc.replaceFirst("\\$u", msgDb.getName());
qc = qc.replaceFirst("\\$d", com.redmoon.forum.ForumSkin.formatDateTime(request, msgDb.getAddDate()));
quotecontent = qc + "\r\n\r\n" + msgDb.getContent();
quotecontent = "<table align=center style=\"width:80%\" cellpadding=5 cellspacing=1 class=quote><TR><TD>" + quotecontent + "</td></tr></table>";

retopic = SkinUtil.LoadString(request, "res.label.forum.addreply", "reply") + retopic;

Leaf lf = new Leaf();
lf = lf.getLeaf(boardcode);
String boardname = lf.getName();
String hit = request.getParameter("hit");

// 取得皮肤路径
String skincode = lf.getSkin();
if (skincode.equals("") || skincode.equals(UserSet.defaultSkin)) {
	skincode = UserSet.getSkin(request);
	if (skincode==null || skincode.equals(""))
		skincode = UserSet.defaultSkin;
}	
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
String skinPath = skin.getPath();

com.redmoon.forum.Config cfg1 = new com.redmoon.forum.Config();
int msgTitleLengthMin = cfg1.getIntProperty("forum.msgTitleLengthMin");
int msgTitleLengthMax = cfg1.getIntProperty("forum.msgTitleLengthMax");
int msgLengthMin = cfg1.getIntProperty("forum.msgLengthMin");
int msgLengthMax = cfg1.getIntProperty("forum.msgLengthMax");
int maxAttachmentCount = cfg1.getIntProperty("forum.maxAttachmentCount");
int maxAttachmentSize = cfg1.getIntProperty("forum.maxAttachmentSize");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.forum.addreply" key="addreply"/> - <%=Global.AppName%></title>
<link href="<%=skinPath%>/skin.css" rel="stylesheet" type="text/css">
<STYLE>
TABLE {
	BORDER-TOP: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: 1px
}
TD {
	BORDER-RIGHT: 0px; BORDER-TOP: 0px
}
body {
	margin-top: 0px;
}
</STYLE>
<script>
function SubmitWithFile(){
	if (!cws_validateMode())
		return false;

	if (document.frmAnnounce.topic.value.length<<%=msgTitleLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_title"/><%=msgTitleLengthMin%>");
		return false;
	}	

	if (document.frmAnnounce.topic.value.length><%=msgTitleLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_title"/><%=msgTitleLengthMax%>");
		return false;
	}	
	
	var html;
	html=cws_getText();
	html=cws_rCode(html,"<a>　</a>","");
 	document.frmAnnounce.Content.value=html;

	if (document.frmAnnounce.Content.value.length<<%=msgLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_content"/><%=msgLengthMin%>");
		return false;
	}
	if (document.frmAnnounce.Content.value.length><%=msgLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_content"/><%=msgLengthMax%>");
		return false;
	}
		
	loadDataToWebeditCtrl(frmAnnounce, frmAnnounce.webedit);
	frmAnnounce.webedit.AddSpecialFile("filename", frmAnnounce.filename.value);
	frmAnnounce.webedit.AddField("ip", "<%=request.getRemoteAddr()%>");
	frmAnnounce.webedit.UploadArticle();
	if (frmAnnounce.webedit.ReturnMessage.indexOf("+")!=-1) {
		alert(frmAnnounce.webedit.ReturnMessage);
		window.location.href = "<%=privurl%>";
	}
	else
		alert(frmAnnounce.webedit.ReturnMessage);
}

function SubmitWithFileDdxc() {
	frmAnnounce.webedit.isDdxc = 1;
	if (document.frmAnnounce.topic.value.length<<%=msgTitleLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_title"/><%=msgTitleLengthMin%>");
		return false;
	}	

	if (document.frmAnnounce.topic.value.length><%=msgTitleLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_title"/><%=msgTitleLengthMax%>");
		return false;
	}	

	var html;
	html=cws_getText();
	html=cws_rCode(html,"<a>　</a>","");
 	document.frmAnnounce.Content.value=html;
	if (document.frmAnnounce.Content.value.length<<%=msgLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_content"/><%=msgLengthMin%>");
		return false;
	}
	if (document.frmAnnounce.Content.value.length><%=msgLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_content"/><%=msgLengthMax%>");
		return false;
	}
		
	loadDataToWebeditCtrl(frmAnnounce, frmAnnounce.webedit);
	frmAnnounce.webedit.AddSpecialFile("filename", frmAnnounce.filename.value);
	frmAnnounce.webedit.AddField("ip", "<%=request.getRemoteAddr()%>");
	frmAnnounce.webedit.MTUpload();
}

function Operate() {
	recordFilePath = frmAnnounce.Recorder.FilePath;
	frmAnnounce.webedit.InsertFileToList(recordFilePath);
}
	
function frmAnnounce_onsubmit()
{
	SubmitWithFile();
}
</script>
<script language=JavaScript src='inc/formpost.js'></script>
</head>
<body>
<%@ include file="inc/header.jsp"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%@ include file="inc/position.jsp"%>
<table width="98%" border="1" align="center" cellpadding="4" cellspacing="0" borderColor="<%=skin.getTableBorderClr()%>">
<form name=frmAnnounce method="post" action="addreplytodb.jsp" enctype="MULTIPART/FORM-DATA" onSubmit="return frmAnnounce_onsubmit()">
    <TBODY>
      <tr> 
      <td colspan="2" background="<%=skinPath%>/images/bg1.gif" class="td_title"> <lt:Label res="res.label.forum.addreply" key="reply_topic"/>&nbsp;<a href="showtopic_tree.jsp?rootid=<%=msgDb.getRootid()%>&showid=<%=msgDb.getId()%>"><%=msgDb.getTitle()%></a>&nbsp;&nbsp;&nbsp;&nbsp;
        <lt:Label res="res.label.forum.addreply" key="board"/>&nbsp;<a class=left href="listtopic.jsp?boardcode=<%=boardcode%>"><%=boardname%></a>&nbsp;</td>
      </tr>
    </TBODY>
    <TBODY>
      <tr>
        <td colspan="2">
          <%
String pluginCode = msgDb.getRootMsgPluginCode();
		  
PluginMgr pm = new PluginMgr();
Vector vplugin = pm.getAllPluginUnitOfBoard(boardcode);
if (vplugin.size()>0) {
	Iterator irplugin = vplugin.iterator();
	long msgRootId = msgDb.getRootid();
	while (irplugin.hasNext()) {
		PluginUnit pu = (PluginUnit)irplugin.next();
		IPluginUI ipu = pu.getUI(request, response, out);
		IPluginViewAddReply pv = ipu.getViewAddReply(boardcode, msgRootId);
		if (pv.IsPluginBoard()) {
			boolean showPlugin = false;
			if (pu.getType().equals(pu.TYPE_BOARD))
				showPlugin = true;
			else if (pu.getType().equals(pu.TYPE_TOPIC)) {
				if (pluginCode.equals(pu.getCode()))
					showPlugin = true;
			}
			if (showPlugin) {				
				if (!pu.getAddReplyPage().equals("")) {
	%>
					<jsp:include page="<%=pu.getAddReplyPage()%>" flush="true">
					<jsp:param name="boardcode" value="<%=StrUtil.UrlEncode(boardcode)%>" /> 
					</jsp:include>
	<%			}
				else {
					out.print(pu.getName(request) + ":&nbsp;" + pv.render(UIAddReply.POS_FORM_NOTE) + "<BR>");
					out.print(pv.render(UIAddReply.POS_FORM_ELEMENT));
				}		
			}	
		}
	}
}
%>        </td>
      </tr>
<%
if (cfg1.getBooleanProperty("forum.addUseValidateCode")) {
%>
<tr><td width="20%">
<lt:Label res="res.label.forum.addtopic" key="input_validatecode"/>
</td><td><input name="validateCode" type="text" size="1">
  <img src='../validatecode.jsp' border=0 align="absmiddle" style="cursor:hand" onClick="this.src='../validatecode.jsp'" alt="<lt:Label res="res.label.forum.index" key="refresh_validatecode"/>"></td>
</tr>	  <%}%>	  
      <tr> 
      <td width="20%"><lt:Label res="res.label.forum.addreply" key="topic_reply"/></td>
        <td width="80%"> <SELECT name=font onchange=DoTitle(this.options[this.selectedIndex].value)>
            <OPTION selected value=""><lt:Label res="res.label.forum.addtopic" key="sel_topic"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_origi"/>><lt:Label res="res.label.forum.addtopic" key="pre_origi"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_from"/>><lt:Label res="res.label.forum.addtopic" key="pre_from"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_water"/>><lt:Label res="res.label.forum.addtopic" key="pre_water"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_discuss"/>><lt:Label res="res.label.forum.addtopic" key="pre_discuss"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_help"/>><lt:Label res="res.label.forum.addtopic" key="pre_help"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_recommend"/>><lt:Label res="res.label.forum.addtopic" key="pre_recommend"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_notice"/>><lt:Label res="res.label.forum.addtopic" key="pre_notice"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_note"/>><lt:Label res="res.label.forum.addtopic" key="pre_note"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_image"/>><lt:Label res="res.label.forum.addtopic" key="pre_image"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_advise"/>><lt:Label res="res.label.forum.addtopic" key="pre_advise"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_download"/>><lt:Label res="res.label.forum.addtopic" key="pre_download"/></OPTION>
            <OPTION value=<lt:Label res="res.label.forum.addtopic" key="pre_share"/>><lt:Label res="res.label.forum.addtopic" key="pre_share"/></OPTION>
          </SELECT> 
		  <input name="topic" type="text" id="topic" size="60" maxlength="80" value="<%=StrUtil.toHtml(retopic)%>">
		  <input type=hidden name=replyid value="<%=replyid%>">
          <input type="hidden" name="boardcode" value="<%=boardcode%>">
          <input type="hidden" name="privurl" value="<%=privurl%>"></td>
      </tr>
      <tr> 
        <td width="20%"><lt:Label res="res.label.forum.addtopic" key="emote_icon"/></td>
        <td width="80%"><iframe src="iframe_emote.jsp" height="25"  width="58%" marginwidth="0" marginheight="0" frameborder="0" scrolling="yes"></iframe>
        <input type="hidden" name="expression" value="25"></td>
      </tr>
      <tr> 
        <td rowspan="2" valign="bottom"><input type="checkbox" name="show_ubbcode" value="0">
          <lt:Label res="res.label.forum.showtopic" key="forbid_ubb"/><br> <input type="checkbox" name="show_smile" value="0">
          <lt:Label res="res.label.forum.showtopic" key="forbid_emote"/><br>        </td>
        <td><table width="100%" border=0 cellspacing=0 cellpadding=0>
<tr><td class=tablebody1 valign=top height=30>
<lt:Label res="res.label.forum.addtopic" key="file"/>
<input type="file" name="filename" size=30>
<select name="select">
  <option>
  <lt:Label res="res.label.forum.addtopic" key="upload_file_ext"/>
  </option>
  <%
				String[] ext = StrUtil.split(cfg1.getProperty("forum.ext"), ",");
				if (ext!=null) {
					int extlen = ext.length;
					for (int p=0; p<extlen; p++) {
						out.print("<option>" + ext[p] + "</option>");
					}
				}
				%>
</select></td>
</tr>
</table></td>
      </tr>
      <tr> 
        <td><%@ include file="../editor_full/editor.jsp"%>
          <input type=hidden name="Content">
          <input type=hidden name="isWebedit" value="<%=MsgDb.WEBEDIT_NORMAL%>">
<%if (quote!=null && quote.equals("1")) {%>
		  <textarea name="tmpContent" style="display:none"><%=quotecontent%></textarea>
		  <script>
		  IframeID.document.body.innerHTML=frmAnnounce.tmpContent.value;
		  </script>
<%}%></td>
      </tr>
      <tr>
        <td valign="bottom">&nbsp;</td>
        <td><table width=""  border="0" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
          <tr>
            <td bgcolor="#FFFFFF"><%
Calendar cal = Calendar.getInstance();
String year = "" + (cal.get(cal.YEAR));
String month = "" + (cal.get(cal.MONTH) + 1);
String filepath = "upfile/webedit/" + year + "/" + month;
%>
                <object classid="CLSID:DE757F80-F499-48D5-BF39-90BC8BA54D8C" codebase="<%=request.getContextPath()%>/activex/webedit.cab#version=6,0,1,1" width=400 height=173 align="middle" id="webedit">
                  <param name="Encode" value="utf-8">
                  <param name="MaxSize" value="<%=Global.MaxSize%>">
                  <!--上传字节-->
                  <param name="ForeColor" value="(255,255,255)">
                  <param name="BgColor" value="(107,154,206)">
                  <param name="ForeColorBar" value="(255,255,255)">
                  <param name="BgColorBar" value="(0,0,255)">
                  <param name="ForeColorBarPre" value="(0,0,0)">
                  <param name="BgColorBarPre" value="(200,200,200)">
                  <param name="FilePath" value="<%=filepath%>">
                  <param name="Relative" value="1">
                  <!--上传后的文件需放在服务器上的路径-->
                  <param name="Server" value="<%=request.getServerName()%>">
                  <param name="Port" value="<%=request.getServerPort()%>">
                  <param name="VirtualPath" value="<%=Global.virtualPath%>">
                  <param name="PostScript" value="<%=Global.virtualPath%>/forum/addreplytodbwe.jsp">
                  <param name="PostScriptDdxc" value="<%=Global.virtualPath%>/forum/forumddxc.jsp">
                  <param name="SegmentLen" value="204800">
              </object></td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><table width="100%" id="table_recorder" style="display:none">
                <tr>
                  <td align="center"><a href="../activex/RecordCtl.EXE"><lt:Label res="res.label.forum.addtopic" key="download_recorder"/></a></td>
                </tr>
                <tr>
                  <td align="center"><OBJECT ID="Recorder" CLASSID="CLSID:E4A3D135-E189-48AF-B348-EF5DFFD99A67">
              </OBJECT></td>
                </tr>
              </table>
                </td>
          </tr>
        </table></td>
      </tr>
      
      <tr>
        <td colspan="2" align="center">
		<!--<input name="cmdok2" type="button" class="singleboarder" value="断点续传" onClick="return SubmitWithFileDdxc()">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
        <input type="button" onClick="frmAnnounce_onsubmit()" value="<lt:Label res="res.label.forum.addtopic" key="commit"/>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="reset" type=reset value="<lt:Label res="res.label.forum.addtopic" key="rewrite"/>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="cmdcancel2" type="button" onClick="table_recorder.style.display=''" value="<lt:Label res="res.label.forum.addtopic" key="record"/>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" onClick="window.location.href='addreply_new.jsp?replyid=<%=replyid%>&boardcode=<%=StrUtil.UrlEncode(boardcode)%>&rootid=<%=msgDb.getRootid()%>&privurl=<%=privurl%>'" value="<lt:Label res="res.label.forum.addtopic" key="add_normal"/>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" onClick="window.location.href='addreply.jsp?replyid=<%=replyid%>&boardcode=<%=StrUtil.UrlEncode(boardcode)%>&rootid=<%=msgDb.getRootid()%>&privurl=<%=privurl%>'" value="<lt:Label res="res.label.forum.addtopic" key="add_ubb"/>"></td>
      </tr>
    </TBODY></form>
</table>
<%@ include file="inc/footer.jsp"%>
</body>
</html>

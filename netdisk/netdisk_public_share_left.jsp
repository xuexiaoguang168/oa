<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.redmoon.oa.netdisk.*" %>
<%@ page import="cn.js.fan.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<LINK href="common.css" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>选择全局共享目录-菜单</title>
<script>
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

function ShowChild(imgobj, name)
{
	var tableobj = findObj("childof"+name);
	if (tableobj.style.display=="none")
	{
		tableobj.style.display = "";
		if (imgobj.src.indexOf("i_puls-root-1.gif")!=-1)
			imgobj.src = "images/i_puls-root.gif";
		if (imgobj.src.indexOf("i_plus-1-1.gif")!=-1)
			imgobj.src = "images/i_plus2-2.gif";
		if (imgobj.src.indexOf("i_plus-1.gif")!=-1)
			imgobj.src = "images/i_plus2-1.gif";
	}
	else
	{
		tableobj.style.display = "none";
		if (imgobj.src.indexOf("i_puls-root.gif")!=-1)
			imgobj.src = "images/i_puls-root-1.gif";
		if (imgobj.src.indexOf("i_plus2-2.gif")!=-1)
			imgobj.src = "images/i_plus-1-1.gif";
		if (imgobj.src.indexOf("i_plus2-1.gif")!=-1)
			imgobj.src = "images/i_plus-1.gif";
	}
}
</script>
</head>
<body>
<table width="100%"  border="0" style="background-image:url(images/bg_left.jpg); background-repeat:no-repeat">
  <tr>
    <td height="73" align="left"><table width="100%"  border="0">
      <tr>
        <td height="33" align="left" style="FILTER: glow(color=ffffff)">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><font color="#0099FF">公共共享</font></strong>&nbsp;<a target="_parent" href="../admin/netdisk_public_dir_frame.jsp"><font color="#999999">[管理]</font></a></td>
      </tr>
      <tr>
        <td align="left">&nbsp;<img src="images/disk.gif" align="absmiddle">&nbsp;<a href="netdisk_frame.jsp" target="_parent">网络硬盘</a>&nbsp;&nbsp;<img src="images/network.gif" width="16" height="16" align="absbottom">&nbsp;<a href="netdisk_neighbor_frame.jsp" target="_parent">网络邻居</a></td>
      </tr>
    </table></td>
  </tr>
</table>
<table width="100%"  border="0">
  <tr>
    <td width="5" align="left">&nbsp;</td>
  <td align="left">
<%
PublicDirectoryView pdv = new PublicDirectoryView(new PublicLeaf(PublicLeaf.ROOTCODE));
pdv.ListSimple(out, "mainPublicShareFrame", "netdisk_public_attach_list.jsp", "", "" );
%>
</td>
  </tr>
</table>
</body>
</html>

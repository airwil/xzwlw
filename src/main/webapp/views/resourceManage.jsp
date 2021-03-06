<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>pictureManger</title>
    <link href="${pageContext.request.contextPath}/css/base.css" type="text/css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/tab.css" type="text/css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/item.css" type="text/css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/item_do.css" type="text/css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/uploadify.css" type="text/css"></link>

    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.uploadify.v2.0.3.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/swfobject.js"></script>
        <%
	String type = request.getParameter("type");
	String grade = request.getParameter("grade");
%>
<body style="margin:1px;" id="ff">
<table id="dg" title="文件管理" class="easyui-datagrid" pagination="true"
       rownumbers="true" fit="true" data-options="pageSize:10"
       url="${pageContext.request.contextPath}/listResource"
       toolbar="#tb">
    <thead data-options="frozen:true">
    <tr>
        <th field="cb" checkbox="true" align="center"></th>
        <th field="id" width="10%" align="center" hidden="true">编号</th>
        <th field="name" width="150" align="center">文件名称</th>
        <th field="fileurl" width="200" align="center">文件位置</th>
        <th field="content" width="70" align="center"
            formatter="formatHref">操作
        </th>
    </tr>
    </thead>
</table>
<div id="tb">
    <div>
        <a href="javascript:openPictureAddDialog()" class="easyui-linkbutton"
           iconCls="icon-add" plain="true">添加</a> <a
            href="javascript:openPictureModifyDialog()"
            class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a> <a
            href="javascript:deletePicture()" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true">删除</a>
    </div>
    <%--<div>
        &nbsp;标题：&nbsp;<input type="text" id="url" size="20"
                              onkeydown="if(event.keyCode==13) searchPicture()"/>&nbsp; <a
            href="javascript:searchPicture()" class="easyui-linkbutton"
            iconCls="icon-search" plain="true">搜索</a>
    </div>--%>
</div>
<div id="dlg" class="easyui-dialog"
     style="width: 600px;height:350px;padding: 10px 20px; position: relative; z-index:1000;"
     closed="true" buttons="#dlg-buttons">
    <form id="fm" method="post" enctype="multipart/form-data">
        <div style="padding-top:50px;  float:left; width:95%; padding-left:30px;">
            <div id="i_do_wrap">

                <div class="i_do_div rel">
                    <p class="i_do_tle r_txt abs font14">文件名称</p>
                    <input type="text" id="title" name="name" class="easyui-validatebox" required="true"
                           style="border:1px #9c9c9c solid;height:25px;"/>
                    <input id="id" name="id" type="hidden" value="0">
                </div>
                <div class="i_do_div rel" id="picture"><p class="i_do_tle r_txt abs font14">文件</p>
                </div>
                <div id="pic11" style="display:none;" class="i_do_div rel">
                </div>
            </div>
        </div>
    </form>
</div>

<div id="dlg-buttons">
    <a href="javascript:savePicture()" class="easyui-linkbutton"
       iconCls="icon-ok">保存</a> <a href="javascript:closePictureDialog()"
                                   class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
</div>


</body>
<script type="text/javascript">
    var url = "${pageContext.request.contextPath}/resource";
    var method;

    function searchPicture() {
        $("#dg").datagrid('load', {
            "url": $("#url").val(),
        });
    }

    function deletePicture() {
        var selectedRows = $("#dg").datagrid('getSelections');
        if (selectedRows.length == 0) {
            $.messager.alert("系统提示", "请选择要删除的数据！");
            return;
        }
        var strIds = [];
        for (var i = 0; i < selectedRows.length; i++) {
            strIds.push(selectedRows[i].id);
        }
        var ids = strIds.join(",");
        $.messager.confirm("系统提示", "您确认要删除这<font color=red>"
                + selectedRows.length + "</font>条数据吗？", function (r) {
            if (r) {
                $.ajax({
                    type: "GET",//方法类型
                    dataType: "json",//预期服务器返回的数据类型
                    url: "/deleteResource/" + ids,//url
                    data: {},
                    success: function (result) {
                        console.log(result);//打印服务端返回的数据
                        if (result.resultCode == 200) {
                            $.messager.alert(
                                    "系统提示",
                                    "数据已成功删除！");
                            $("#dg").datagrid(
                                    "reload");
                        }
                        else {
                            $.messager.alert(
                                    "系统提示",
                                    "数据删除失败！");
                        }

                        ;
                    },
                    error: function () {
                        $.messager.alert("ERROR！");
                    }
                });
            }
        });

    }
    function openPictureAddDialog() {
        $("#dlg").dialog("open").dialog("setTitle", "添加文件");
        var html = '<img name="uploadify2" id="uploadify2"  type="file" />';
        $('#picture').append(html);
        var imghtml = '<img src="images/back.jpg" width="110" height="110" id="img11"  style="display:none;"/><input type="text" id="input11" name="path" value="" style="display:none;" />';
        $('#pic11').append(imghtml);
        initUploadify();
        method = "POST";
    }


    function savePicture() {
        var id = $("#id").val();
        var title=$("#title").val();
        var path = $("#input11").val();
        console.log("图片路径："+path);
        var data = {"id": id, "name": title,"fileurl": path};
        $.ajax({
            type: method,//方法类型
            dataType: "json",//预期服务器返回的数据类型
            url: url,//url
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(data),
            success: function (result) {
                console.log(result);//打印服务端返回的数据
                if (result.resultCode == 200) {
                    $.messager.alert("系统提示", "保存成功");
                    $("#dlg").dialog("close");
                    $("#dg").datagrid("reload");
                    resetValue();
                }
                else {
                    $.messager.alert("系统提示", "操作失败");
                    $("#dlg").dialog("close");
                    resetValue();
                }
                ;
            },
            error: function () {
                $.messager.alert("系统提示", "操作失败");
            }
        });
    }

    function openPictureModifyDialog() {
        var selectedRows = $("#dg").datagrid('getSelections');
        var row = selectedRows[0];
        var html = '<img name="uploadify2" id="uploadify2"  type="file" />';
        $('#picture').append(html);
        var imghtml =
            '<img src="images/back.jpg" width="110" height="110" id="img11" style="display:none;"/><input type="text" id="input11" name="path" value="' + row.fileurl + '" style="display:none;" />';
        $('#pic11').append(imghtml);
        if (selectedRows.length != 1) {
            $.messager.alert("系统提示", "请选择一条要编辑的数据！");
            return;
        }
        initUploadify();
        $("#dlg").dialog("open").dialog("setTitle", "修改信息");
        $('#fm').form('load', row);
        $("#id").val(row.id);
        method = "PUT";
    }

    function formatProPic(val, row) {
        return "<img width=100 height=100 src='${pageContext.request.contextPath}/" + val + "'>";
    }

    function resetValue() {
        $("#title").val("");
        $("#path").val("");
        $("#title").val("");
        $("#desc").val("");
        $('#picture').find('img').remove();
        $('#pic11').find('input').remove();
        $('#pic11').find('img').remove();
    }

    function closePictureDialog() {
        $("#dlg").dialog("close");
        resetValue();
    }

    function formatHref(val, row) {
        return "<a href='${pageContext.request.contextPath}/downfile/" + row.id + "' target='_blank'>下载</a>";
    }

    function initUploadify() {
        $("#uploadify2").uploadify({
            'uploader': 'swf/uploadify2.swf', 			//flash文件的相对路径
            'script': '/uploadFile',  				//后台处理程序的路径
            'fileDataName': 'file', 						//设置上传文件名称,默认为Filedata
            'cancelImg': 'images/cancel.png', 			//每一个文件上的关闭按钮图标
            'queueID': 'div_progress', 					//文件队列的ID，该ID与存放文件队列的div的ID一致
            'queueSizeLimit': 1, 							//当允许多文件生成时，设置选择文件的个数，默认值：999
            'fileDesc': '*.jpg;*.gif;*.png;*.ppt;*.pdf;*.jpeg', 	//用来设置选择文件对话框中的提示文本
            'fileExt': '*.*', 		//设置可以选择的文件的类型
            'auto': true, 								//设置为true当选择文件后就直接上传了，为false需要点击上传按钮才上传
            'multi': true, 								//设置为true时可以上传多个文件
            'simUploadLimit': 1, 						//允许同时上传的个数 默认值：1
            'sizeLimit': 2048000,						//上传文件的大小限制
            'buttonText': '上传文件',						//浏览按钮的文本，默认值：BROWSE
            'displayData': 'percentage',     			//上传队列显示的数据类型，percentage是百分比，speed是上传速度
            //回调函数
            'onComplete': function (evt, queueID, fileObj, response, data) {
                var imgUrl = JSON.parse(response).data;
                $("#input11").val(imgUrl);
                $("#pic11").removeAttr("style");
                $("#img11").removeAttr("style");
                return false;
            },
            'onError': function (event, queueID, fileObj, errorObj) {
                if (errorObj.type === "File Size") {
                    alert("文件最大为3M");
                    $("#uploadify").uploadifyClearQueue();
                }
            },
            'onQueueFull': function (event, queueSizeLimit) {
                alert("最多上传" + queueSizeLimit + "张图片");
                return false;
            }
        });
    }
</script>
</head>

</html>
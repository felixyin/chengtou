<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>人员评分管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            //$("#name").focus();
            $("#inputForm").validate({
                submitHandler: function (form) {
                    loading('正在提交，请稍等...');
                    form.submit();
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
        });

        function addRow(list, idx, tpl, row) {
            $(list).append(Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            }));
            $(list + idx).find("select").each(function () {
                $(this).val($(this).attr("data-value"));
            });
            $(list + idx).find("input[type='checkbox'], input[type='radio']").each(function () {
                var ss = $(this).attr("data-value").split(',');
                for (var i = 0; i < ss.length; i++) {
                    if ($(this).val() == ss[i]) {
                        $(this).attr("checked", "checked");
                    }
                }
            });
        }

        function delRow(obj, prefix) {
            var id = $(prefix + "_id");
            var delFlag = $(prefix + "_delFlag");
            if (id.val() == "") {
                $(obj).parent().parent().remove();
            } else if (delFlag.val() == "0") {
                delFlag.val("1");
                $(obj).html("&divide;").attr("title", "撤销删除");
                $(obj).parent().parent().addClass("error");
            } else if (delFlag.val() == "1") {
                delFlag.val("0");
                $(obj).html("&times;").attr("title", "删除");
                $(obj).parent().parent().removeClass("error");
            }
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li><a href="${ctx}/estimate/userEstimate/">人员评分列表</a></li>
    <li class="active"><a href="${ctx}/estimate/userEstimate/form?id=${userEstimate.id}">人员评分<shiro:hasPermission
            name="estimate:userEstimate:edit">${not empty userEstimate.id?(isForEdit?'修改':'查看'):'添加'}</shiro:hasPermission><shiro:lacksPermission
            name="estimate:userEstimate:edit">查看</shiro:lacksPermission></a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="userEstimate" action="${ctx}/estimate/userEstimate/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>

        <table>
            <tr>
                <td>
                    <div class="control-group">
                        <label class="control-label">姓名：</label>
                        <div class="controls">
                                ${userEstimate.name}
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label">登录名：</label>
                        <div class="controls">
                                ${userEstimate.loginName}
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label">工号：</label>
                        <div class="controls">
                                ${userEstimate.no}
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="control-group">
                        <label class="control-label">用户类型：</label>
                        <div class="controls">
                            <c:set var="userType" value="${userEstimate.userType}"></c:set>
                                ${fns:getDictLabel(userType,'sys_user_type','')}
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label">归属部门：</label>
                        <div class="controls">
                                ${userEstimate.office}
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label">评分合计：</label>
                        <div class="controls">
                                ${userEstimate.fraction}
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <div class="control-group">
            <label class="control-label">评分明细：</label>
            <div class="controls">
                <table id="contentTable" class="table table-striped table-bordered table-condensed">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>分数</th>
                        <th>进展情况</th>
                        <th>备注信息</th>
                        <th>评分日期</th>
                        <th>项目编号</th>
                            <%--<th>操作</th>--%>
                            <%--<shiro:hasPermission name="estimate:userEstimate:edit">--%>
                            <%--<th width="10">&nbsp;</th>--%>
                            <%--</shiro:hasPermission>--%>
                    </tr>
                    </thead>
                    <tbody id="userEstimateDetailList">
                    </tbody>
                </table>
                <script type="text/template" id="userEstimateDetailTpl">//<!--
                            <tr id="userEstimateDetailList{{idx}}">
                                <td class="hide">
                                    <input id="userEstimateDetailList{{idx}}_id" name="userEstimateDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="userEstimateDetailList{{idx}}_delFlag" name="userEstimateDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td>
                                {{row.fraction}}
                                </td>
                                <td>
                                {{row.evolve}}
                                </td>
                                <td>
                                {{row.remarks}}
                                </td>
                                <td>
                                {{row.updateDate}}
                                </td>
                                <td>
                                    <a href="javascript:showDialogByUrl('${ctx}/project/aamsProject/route?id={{row.projectId}}','查看详情，项目编号：{{row.num}}');"
                           >
                                    {{row.num}}
                                    </a>
                                </td>
                                <%--<shiro:hasPermission name="project:aamsProject:approve">--%>
                                <%--<td>--%>
                                    <%--&lt;%&ndash;<a href="javascript:showDialogByUrl('${ctx}/approve/estimate/oaEstimateApprove/preApprove?estimate.id={{row.id}}','改分申请');">改分申请</a>&ndash;%&gt;--%>
                                    <%--{{#row.oaEstimateApprove.id}}--%>
                                        <%--<a href="${ctx}/approve/estimate/oaEstimateApprove/form?id={{row.oaEstimateApprove.id}}">审批查看</a>--%>
                                    <%--{{/row.oaEstimateApprove.id}}--%>
                                    <%--{{^row.oaEstimateApprove.id}}--%>
                                        <%--<a href="${ctx}/approve/estimate/oaEstimateApprove/preApprove?estimate.id={{row.id}}">改分申请</a>--%>
                                    <%--{{/row.oaEstimateApprove.id}}--%>
                                <%--</td>--%>
                                <%--</shiro:hasPermission>--%>
                            </tr>//-->
                </script>
                <script type="text/javascript">
                    var userEstimateDetailRowIdx = 0,
                        userEstimateDetailTpl = $("#userEstimateDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");
                    $(document).ready(function () {
                        var data = ${fns:toJson(userEstimate.userEstimateDetailList)};
                        for (var i = 0; i < data.length; i++) {
                            var d = data[i];
                            addRow('#userEstimateDetailList', userEstimateDetailRowIdx, userEstimateDetailTpl, d);
                            userEstimateDetailRowIdx = userEstimateDetailRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>
        <div class="form-actions my-form-actions">
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>
    </form:form>
</div>
</body>
</html>
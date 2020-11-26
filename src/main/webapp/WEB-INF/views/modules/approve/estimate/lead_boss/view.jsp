<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>评分审批查看</title>
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
    </script>
</head>
<body>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="oaEstimateApprove" action="${ctx}/approve/estimate/oaEstimateApprove/save"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>
        <div class="control-group hide">
            <label class="control-label">流程实例编号：</label>
            <div class="controls">
                    ${oaEstimateApprove.procInsId}
            </div>
        </div>
        <div class="control-group hide">
            <label class="control-label">申请人主键：</label>
            <div class="controls">
                    ${oaEstimateApprove.approveUser.id}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请人：</label>
            <div class="controls">
                    ${oaEstimateApprove.approveUser.name}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">原评分：</label>
            <div class="controls">
                    ${oaEstimateApprove.estimate.fraction}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                    <pre>
                            ${oaEstimateApprove.estimate.evolve}
                    </pre>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请评分：</label>
            <div class="controls">
                    ${oaEstimateApprove.fractionApprove}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请原因：</label>
            <div class="controls">
                    <pre>
                            ${oaEstimateApprove.reason}
                    </pre>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人：</label>
            <div class="controls">
                    ${oaEstimateApprove.bossUser.name}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人审批意见：</label>
            <div class="controls">
                    <pre>
                            ${oaEstimateApprove.bossSuggest}
                    </pre>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">单位负责人审批时间：</label>
            <div class="controls">
                <fmt:formatDate value="${oaEstimateApprove.bossTime}" pattern="yyyy-MM-dd"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">管理员：</label>
            <div class="controls">
                    ${oaEstimateApprove.adminUser.name}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员流转备注：</label>
            <div class="controls">
                    <pre>
                            ${oaEstimateApprove.adminSuggest}
                    </pre>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员操作时间：</label>
            <div class="controls">
                <fmt:formatDate value="${oaEstimateApprove.adminTime}" pattern="yyyy-MM-dd"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">审批结果：</label>
            <div class="controls">
                <form:select path="bossResult" class="input-xlarge " readonly="true" disabled="true">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('approve_result')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </div>
        </div>
        <%--<div class="control-group">--%>
        <%--<label class="control-label">备注信息：</label>--%>
        <%--<div class="controls">--%>
        <%--<pre>--%>
        <%--${oaEstimateApprove.remarks}--%>
        <%--</pre>--%>
        <%--</div>--%>
        <%--</div>--%>
        <%--<div class="control-group">--%>
        <%--<label class="control-label">状态：</label>--%>
        <%--<div class="controls">--%>
        <%--<form:select path="status" class="input-xlarge " readonly="true" disabled="true">--%>
        <%--<form:option value="" label=""/>--%>
        <%--<form:options items="${fns:getDictList('approve_status')}" itemLabel="label" itemValue="value"--%>
        <%--htmlEscape="false"/>--%>
        <%--</form:select>--%>
        <%--</div>--%>
        <%--</div>--%>

        <c:if test="${not empty oaEstimateApprove.id}">
            <act:histoicFlow procInsId="${oaEstimateApprove.act.procInsId}"/>
        </c:if>

        <div class="form-actions my-form-actions">
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>

    </form:form>
</div>
</body>
</html>
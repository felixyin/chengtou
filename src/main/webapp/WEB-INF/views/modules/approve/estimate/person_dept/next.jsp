<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>评分明细</title>
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
<div class="header">
    <div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}">
        <button data-dismiss="alert" class="close">×</button>
        <label id="loginError" class="error">${message}</label>
    </div>
</div>
<ul class="nav nav-tabs my-nav-tabs">
    <%--<li><a href="${ctx}/estimate/userEstimateDetail/">评分明细列表</a></li>--%>
    <li class="active"><a
            href="${ctx}/approve/estimate/oaEstimateApprove/form?id=${oaEstimateApprove.id}">改分审批</a></li>
</ul>
<br/>
<div class="my-container">
    <form:form id="inputForm" modelAttribute="oaEstimateApprove"
               action="${ctx}/approve/estimate/oaEstimateApprove/saveSuggestions"
               method="post" class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="act.taskId"/>
        <form:hidden path="act.taskName"/>
        <form:hidden path="act.taskDefKey"/>
        <form:hidden path="act.procInsId"/>
        <form:hidden path="act.procDefId"/>
        <form:hidden id="flag" path="act.flag"/>
        <sys:message content="${message}"/>
        <div class="control-group hide">
            <label class="control-label">流程实例编号：</label>
            <div class="controls">
                <form:input path="procInsId" htmlEscape="false" maxlength="64" class="input-xlarge "/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请人用户外键：</label>
            <div class="controls">
                <sys:treeselect id="user" name="approveUser.id" value="${oaEstimateApprove.approveUser.id}"
                                labelName="approveUser.name"
                                labelValue="${oaEstimateApprove.approveUser.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
                                notAllowSelectParent="true" disabled="disabled"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">原评分：</label>
            <div class="controls">
                <form:input path="estimate.fraction" htmlEscape="false" maxlength="11" class="input-xlarge "
                            readonly="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                <form:textarea path="estimate.evolve" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "
                               readonly="true"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">申请评分：</label>
            <div class="controls">
                <form:input path="fractionApprove" htmlEscape="false" maxlength="11" class="input-xlarge "
                            readonly="${fn:contains(roleStr, 'p')?'false':'true'}"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">申请原因：</label>
            <div class="controls">
                <form:textarea path="reason" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "
                               readonly="${fn:contains(roleStr, 'p')?'false':'true'}"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">部门长：</label>
            <div class="controls">
                <sys:treeselect id="bumenUser" name="bumenUser.id"
                                value="${oaEstimateApprove.bumenUser.id}"
                                labelName="user.name" labelValue="${oaEstimateApprove.bumenUser.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
                                notAllowSelectParent="true"
                                disabled="${fn:contains(roleStr, 'p')?'':'disabled'}"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">部门长意见：</label>
            <div class="controls">
                <form:textarea path="bumenSuggest" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "
                               readonly="${fn:contains(roleStr, 'b')?'false':'true'}"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员：</label>
            <div class="controls">
                <sys:treeselect id="adminUser" name="adminUser.id" value="${oaEstimateApprove.adminUser.id}"
                                labelName="user.name" labelValue="${oaEstimateApprove.adminUser.name}"
                                title="用户" url="/sys/office/treeData?type=3" cssClass="" allowClear="true"
                                notAllowSelectParent="true"
                                disabled="disabled"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">管理员流转备注：</label>
            <div class="controls">
                <form:textarea path="adminSuggest" htmlEscape="false" rows="4" maxlength="500" class="input-xxlarge "
                               readonly="${fn:contains(roleStr, 'g')?'false':'true'}"/>
            </div>
        </div>
        <c:if test="${fn:contains(roleStr, 'z')}">
            <div class="control-group ">
                <label class="control-label">审批结果：</label>
                <div class="controls">
                    <form:radiobuttons path="bossResult" items="${fns:getDictList('approve_result')}" itemLabel="label"
                                       itemValue="value" htmlEscape="false" class=""/>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty oaEstimateApprove.id}">
            <act:histoicFlow procInsId="${oaEstimateApprove.act.procInsId}"/>
        </c:if>

        <div class="form-actions my-form-actions">
            <shiro:hasPermission name="approve:estimate:oaEstimateApprove:edit">
                <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
            </shiro:hasPermission>
            <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
        </div>


    </form:form>
</div>
</body>
</html>
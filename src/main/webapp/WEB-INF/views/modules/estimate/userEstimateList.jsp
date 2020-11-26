<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>人员评分管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {

        });

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/estimate/userEstimate/">人员评分列表</a></li>
    <%--<shiro:hasPermission name="estimate:userEstimate:edit"><li><a href="${ctx}/estimate/userEstimate/form">人员评分添加</a></li></shiro:hasPermission>--%>
</ul>
<div class="my-list-container">
    <form:form id="searchForm" modelAttribute="userEstimate" action="${ctx}/estimate/userEstimate/" method="post"
               class="breadcrumb form-search">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <ul class="ul-form">
            <li><label>姓名：</label>
                    <form:input path="name" htmlEscape="false" maxlength="100" class="input-medium"/>
            </li>
            <li><label>登录名：</label>
                <form:input path="loginName" htmlEscape="false" maxlength="100" class="input-medium"/>
            </li>
            <li><label>工号：</label>
                <form:input path="no" htmlEscape="false" maxlength="100" class="input-medium"/>
            </li>
            <li><label>用户类型：</label>
                <form:select path="userType" class="input-medium">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
            <li><label>归属部门：</label>
                <sys:treeselect id="office" name="office.id" value="${userEstimate.office.id}" labelName="office.name"
                                labelValue="${userEstimate.office.name}"
                                title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true"
                                notAllowSelectParent="true"/>
            </li>
            <li>
                <label>年度：</label>
                <form:select path="year" class="input-medium">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('sys_score_year')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
            <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
            <li class="clearfix"></li>
        </ul>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-striped table-bordered table-condensed">
        <thead>
        <tr>
            <th>序号</th>
            <th>姓名</th>
            <th>登录名</th>
            <th>工号</th>
            <%--<th>用户类型</th>--%>
            <th>归属部门</th>
            <th>年度</th>
            <th>项目评分</th>
            <th>比率评分</th>
            <th>所占比率</th>
            <th>考勤扣分</th>
            <th>总评分</th>
            <%--<shiro:hasPermission name="estimate:userEstimate:edit"><th>操作</th></shiro:hasPermission>--%>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="userEstimate">
            <tr>
                <td>
                        ${userEstimate.seq}
                </td>
                <td>
                        ${userEstimate.name}
                </td>
                <td>
                        ${userEstimate.loginName}
                </td>
                <td>
                        ${userEstimate.no}
                </td>
                    <%--<td>--%>
                    <%--${fns:getDictLabel(userEstimate.userType, 'sys_user_type', '')}--%>
                    <%--</td>--%>
                <td>
                        ${userEstimate.office.name}
                </td>
                <td>
                        ${userEstimate.year}
                </td>
                <td>
                    <a href="${ctx}/estimate/userEstimate/view?id=${userEstimate.id}&year=${userEstimate.year}">
                            ${userEstimate.fraction}
                    </a>
                </td>
                <td>
                        ${userEstimate.fractionRatio}
                </td>
                <td>
                    <fmt:formatNumber value="${userEstimate.ratio}" maxIntegerDigits="3" minFractionDigits="2" type="percent"/>
                </td>
                <td>
                    <a href="javascript:showDialogByUrl('${ctx}/atten/aamsAtten?userId=${userEstimate.id}&year=${userEstimate.year}','${userEstimate.name}的考勤记录');"
                       >
                            ${userEstimate.attenFraction}
                    </a>
                </td>
                    <%--<td>--%>
                    <%--<a href="${ctx}/atten/aamsAtten?userId=${userEstimate.id}&year=${userEstimate.year}">--%>
                    <%--${userEstimate.attenFraction}--%>
                    <%--</a>--%>
                    <%--</td>--%>
                <td>
                        ${userEstimate.zongFraction}
                </td>
                    <%--<shiro:hasPermission name="estimate:userEstimate:edit"><td>--%>
                    <%--<a href="${ctx}/estimate/userEstimate/form?id=${userEstimate.id}">修改</a>--%>
                    <%--<a href="${ctx}/estimate/userEstimate/delete?id=${userEstimate.id}" onclick="return confirmx('确认要删除该人员评分吗？', this.href)">删除</a>--%>
                    <%--</td></shiro:hasPermission>--%>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="pagination">${page}</div>
</div>
</body>
</html>
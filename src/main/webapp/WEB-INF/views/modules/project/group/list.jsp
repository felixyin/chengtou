<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>集团督办项目管理</title>
    <meta name="decorator" content="default"/>
    <%--<link rel="stylesheet" href="${ctxStatic}/tablednd/tablednd.css">--%>
    <style rel="stylesheet">
        .tDnD_whileDrag td {
            background-color: #eee;
            -webkit-box-shadow: 6px 3px 5px #555, 0 1px 0 #ccc inset, 0 -1px 0 #ccc inset;
        }

        .tDnD_whileDrag td:last-child {
            -webkit-box-shadow: 1px 8px 6px -4px #555, 0 1px 0 #ccc inset, 0 -1px 0 #ccc inset;
        }

        .showDragHandle {
            background-image: url('${ctxStatic}/tablednd/updown2.gif');
            background-repeat: no-repeat;
            background-position: center center;
            cursor: move;
        }

        #dndTable > tr > td {
            cursor: default;
        }

        #dndTable > tr > td:first-child {
            cursor: move;
        }
    </style>
    <script type="text/javascript" src="${ctxStatic}/tablednd/jquery.tablednd.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.my-tip').popover({});
            <shiro:hasPermission name="project:group:order">
            $("#dndTable").tableDnD({
                onDragClass: 'tDnD_whileDrag',
                onDrop: function (table, row) {
                    var data = $('.my-drag').map(function (index, item) {
                        var data = $(this).data();
                        var num = index + 1;
                        if (num != data.oldSeq) {
                            return {
                                oldSeq: data.oldSeq,
                                orderNum: num,
                                id: data.id
                            };
                        }
                    }).get();
                    if (data.length) { // 顺序有变化，则提交后台保存
                        $.ajax({
                            type: "POST",
                            url: "${ctx}/project/aamsProject/saveOrderNum",
                            dataType: "json",
                            contentType: "application/json",
                            data: JSON.stringify(data),
                            success: function (data) {
                                if (data) {
                                    top.$.jBox.messager('项目排序修改成功!', '消息提示');
                                    $('.my-drag').each(function (index, item) {
                                        var data = $(this).data();
                                        var num = index + 1;
                                        if (num != data.oldSeq) {
                                            $(this).text(num).data('oldSeq', num);
                                        }
                                    });
                                } else {
                                    top.$.jBox.messager('项目排序修改失败!', '消息提示');
                                    setTimeout(function () {
                                        window.location.reload();
                                    }, 2000);
                                }
                            }
                        });
                    }
                }
            });
            </shiro:hasPermission>

            $("#dndTable").children("tr").hover(function () {
                $(this.cells).css('background', '#E4E4E4').eq(0).addClass('showDragHandle');
            }, function () {
                $(this.cells).css('background', '').eq(0).removeClass('showDragHandle');
            }).click(function () {//点击背景变色
                if (window._preCells) $(window._preCells).removeClass('my-text-shadow');
                $(window._preCells = this.cells).addClass('my-text-shadow');
            });
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
    <li class="active"><a href="${ctx}/project/group/">集团督办项目列表</a></li>
    <shiro:hasPermission name="project:group:add">
        <li><a href="${ctx}/project/group/form">集团督办项目添加</a></li>
    </shiro:hasPermission>
    <li><a href="javascript:$('#searchForm').toggle()"><i class="icon-search"></i></a></li>
</ul>
<div class="my-list-container">
    <form:form id="searchForm" modelAttribute="aamsProject" action="${ctx}/project/group/" method="post"
               class="breadcrumb form-search" style="display:none;">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
        <ul class="ul-form">
            <li><label>项目编号：</label>
                <form:input path="num" htmlEscape="false" maxlength="20" class="input-medium"/>
            </li>

            <li><label>督办事项：</label>
                <form:input path="items" htmlEscape="false" maxlength="500" class="input-medium"/>
            </li>
            <%--<li><label>督办类型：</label>--%>
                <%--<form:select path="type" class="input-medium">--%>
                    <%--<form:option value="" label=""/>--%>
                    <%--<form:options items="${fns:getDictList('project_type')}" itemLabel="label" itemValue="value"--%>
                                  <%--htmlEscape="false"/>--%>
                <%--</form:select>--%>
            <%--</li>--%>
            <li><label>紧急级别：</label>
                <form:select path="level" class="input-medium ">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('project_level')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
            <li><label>来源：</label>
                <form:input path="source" htmlEscape="false" maxlength="100" class="input-medium"/>
            </li>

            <li><label>责任人：</label>
                <form:input path="userNames" htmlEscape="false" maxlength="20" class="input-medium"/>
            </li>
            <li><label>责任部门：</label>
                <sys:treeselect id="office" name="office.id" value="${aamsProject.office.id}" labelName="office.name"
                                labelValue="${aamsProject.office.name}"
                                title="部门" url="/sys/office/treeData?type=2" cssClass="input-small" allowClear="true"
                                notAllowSelectParent="true"/>
            </li>
            <li><label>工作计划：</label>
                <form:input path="jobPlain" htmlEscape="false" maxlength="500" class="input-medium"/>
            </li>
            <li><label>备注：</label>
                <form:input path="comments" htmlEscape="false" maxlength="500" class="input-medium"/>
            </li>
            <li><label>状态：</label>
                <form:select path="status" class="input-medium">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('project_types')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
            <li><label>办结时限：</label>
                <input name="beginWillFinishTime" type="text" readonly="readonly" maxlength="20"
                       class="input-m Wdate"
                       value="<fmt:formatDate value="${aamsProject.beginWillFinishTime}" pattern="MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'MM-dd',isShowClear:false});"/> -
                <input name="endWillFinishTime" type="text" readonly="readonly" maxlength="20"
                       class="input-m Wdate"
                       value="<fmt:formatDate value="${aamsProject.endWillFinishTime}" pattern="MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'MM-dd',isShowClear:false});"/>
            </li>
            <li><label>结束日期：</label>
                <input name="beginEndTime" type="text" readonly="readonly" maxlength="20" class="input-m Wdate"
                       value="<fmt:formatDate value="${aamsProject.beginEndTime}" pattern="MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'MM-dd',isShowClear:false});"/> -
                <input name="endEndTime" type="text" readonly="readonly" maxlength="20" class="input-m Wdate"
                       value="<fmt:formatDate value="${aamsProject.endEndTime}" pattern="MM-dd"/>"
                       onclick="WdatePicker({dateFmt:'MM-dd',isShowClear:false});"/>
            </li>
            <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
            <li class="clearfix"></li>
        </ul>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-striped table-bordered table-condensed default-table-tr-border">
        <thead>
        <tr>
            <th>序号</th>
            <th class="sort-column num">项目编号</th>
            <th class="sort-column type">项目类型</th>
            <th class="sort-column level">紧急级别</th>
            <th>督办事项</th>
            <th>来源</th>
            <th>责任部门</th>
            <th>责任人</th>
            <th>工作计划</th>
            <th>备注</th>
            <th class="sort-column willFinishTime">办结时限</th>
            <th class="sort-column endTime">归档日期</th>
            <th class="sort-column status" style="min-width: 50px;">状态</th>
            <shiro:hasPermission name="project:group:edit">
                <th>操作</th>
            </shiro:hasPermission>
        </tr>
        </thead>
        <tbody id="dndTable">
        <c:forEach items="${page.list}" var="aamsProject" varStatus="status">
            <tr>
                <td class="my-drag" data-old-seq="${aamsProject.seq}" data-id="${aamsProject.id}">
                        ${aamsProject.seq}
                </td>
                <td>
                    <a href="javascript:showDialogByUrl('${ctx}/project/group/view?id=${aamsProject.id}','查看详情，项目编号：${aamsProject.num}');"
                       >
                            ${aamsProject.num}
                    </a>
                </td>
                <td>
                    <span class="label label-${fns:getDict(aamsProject.type, 'project_type').remarks}">
                            ${fns:getDict(aamsProject.type, 'project_type').label}
                    </span>
                </td>
                <td>
                    <span class="label label-${fns:getDict(aamsProject.level, 'project_level').remarks}">
                            ${fns:getDict(aamsProject.level, 'project_level').label}
                    </span>
                </td>
                <td>
                    <textarea id="td-item-${status.index}" style="display:none;">
                            ${aamsProject.items}
                    </textarea>
                    <a href="javascript:showDialogByIdVal('td-item-${status.index}','督办事项，项目编号：${aamsProject.num}');">
                            ${fns:abbr(fns:replaceHtml(aamsProject.items),45)}
                    </a>
                </td>
                <td>
                    <a href="javascript:void(0);" class="my-tip" title="" data-placement="right"
                       data-content="${aamsProject.source}">
                            ${ fn:substring(aamsProject.source,0,5)}...
                    </a>
                </td>
                <td>
                        ${aamsProject.office.name}
                </td>
                <td>
                        ${aamsProject.userNames}
                </td>
                <td>
                    <textarea id="td-job-plain-${status.index}" style="display:none;">
                            ${aamsProject.jobPlain}
                    </textarea>
                    <a href="javascript:showDialogByIdVal('td-job-plain-${status.index}','工作计划，项目编号：${aamsProject.num}');">
                            ${fns:abbr(fns:replaceHtml(aamsProject.jobPlain),45)}
                    </a>
                </td>
                <td>
                    <a href="javascript:void(0);" class="my-tip" title="" data-placement="left"
                       data-content="${aamsProject.comments}">
                            ${ fn:substring(aamsProject.comments,0,5)}...
                    </a>
                </td>
                <td>
                    <fmt:formatDate value="${aamsProject.willFinishTime}" pattern="MM-dd"/>
                </td>
                <td>
                    <fmt:formatDate value="${aamsProject.endTime}" pattern="MM-dd"/>
                </td>
                <td>
                        ${fns:getDictLabel(aamsProject.status, 'project_types', '')}
                </td>
                <shiro:hasPermission name="project:group:edit">
                    <td>
                        <a href="${ctx}/project/group/form?id=${aamsProject.id}">修改</a>
                    </td>
                </shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="pagination">${page}</div>
</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>个人督办项目管理</title>
    <meta name="decorator" content="default"/>
    <style rel="stylesheet">
        /* textarea 自适应父容器大小 */
        .ttarea {
            width: 90%; /*自动适应父布局宽度*/
            overflow: auto;
            word-break: break-all;
            /*在ie中解决断行问题(防止自动变为在一行显示，主要解决ie兼容问题，ie8中当设宽度为100%时，文本域类容超过一行时，当我们双击文本内容就会自动变为一行显示，所以只能用ie的专有断行属性“word-break或word-wrap”控制其断行)*/
        }

        .readonly-select {
            border: 0 !important;
            background-color: rgba(0, 0, 0, 0) !important;
        }

        .readonly-select + a {
            display: none;
        }

        .my-parent-tr > td{
            background-color: lightblue!important;
        }
    </style>
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

        function addParentRow(list, idx, tpl, row) {
            window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] = 0;
            addRow(list, idx, tpl, row)
        }

        function addSubRow(list, owner, idx, tpl, row) {
            var parentIdx = '';
            if (typeof(owner) == 'number') {
                parentIdx = owner;
            } else {
                parentIdx = $(owner).data('parent');
            }
            $(list).append(Mustache.render(tpl, {
                parentIdx: parentIdx, idx: idx, delBtn: true, row: row
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

        function addSubTable(list, idx, tpl, row) {
            var html = Mustache.render(tpl, {
                idx: idx, delBtn: true, row: row
            });
            $(list).append(html);
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

<div class="my-container" style="overflow: hidden">
    <form:form id="inputForm" modelAttribute="aamsProject" action="${ctx}/project/my/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <sys:message content="${message}"/>

        <div class="control-group hide">
            <label class="control-label">督办类型：</label>
            <div class="controls">
                    ${fns:getDictLabel(aamsProject.type, 'project_type','')}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">紧急级别：</label>
            <div class="controls">
                    ${fns:getDictLabel(aamsProject.level, 'project_level','')}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">督办事项：</label>
            <div class="controls">
            </div>
            <textarea class="html-decode-ttarea hide">
                    ${aamsProject.items}
            </textarea>
        </div>
        <div class="control-group">
            <label class="control-label">来源：</label>
            <div class="controls">
                    ${aamsProject.source}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">责任部门：</label>
            <div class="controls">
                    ${aamsProject.office}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">工作计划：</label>
            <div class="controls">
            </div>
            <textarea class="html-decode-ttarea hide">
                    ${aamsProject.jobPlain}
            </textarea>
        </div>
        <div class="control-group">
            <label class="control-label">办结时限：</label>
            <div class="controls">
                <fmt:formatDate value="${aamsProject.willFinishTime}" pattern="yyyy-MM-dd"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">进展情况：</label>
            <div class="controls">
                    ${aamsProject.evolve}
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">备注：</label>
            <div class="controls">
                    ${aamsProject.comments}
            </div>
        </div>
        <%--<div class="control-group">--%>
        <%--<label class="control-label">归档日期：</label>--%>
        <%--<div class="controls">--%>
        <%--<input name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate "--%>
        <%--value="<fmt:formatDate value="${aamsProject.endTime}" pattern="yyyy-MM-dd"/>"--%>
        <%--onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>--%>
        <%--</div>--%>
        <%--</div>--%>
        <div class="control-group">
            <label class="control-label">附件：</label>
            <div class="controls">
                <form:hidden id="files" path="files" htmlEscape="false" maxlength="500" class="input-xlarge"/>
                <sys:ckfinder input="files" type="files" uploadPath="/project/my" selectMultiple="true"
                              readonly="true"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">状态：</label>
            <div class="controls">
                    ${fns:getDictLabel(aamsProject.status, 'project_types','')}
            </div>
        </div>


        <script type="text/template" id="aamsEstimateTpl">//<!--
            <tr id="aamsEstimateListDel{{parentIdx}}{{idx}}">
                <td class="hide">
                    <input id="aamsEstimateListDel{{parentIdx}}{{idx}}_id" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                    <input id="aamsEstimateListDel{{parentIdx}}{{idx}}_delFlag" name="aamsProjectUserList[{{parentIdx}}].aamsEstimateList[{{idx}}].delFlag" type="hidden" value="0"/>
                </td>
                <td style="width:150px">
                    {{row.fraction}}
                </td>
                <td style="width:60%">
                    {{row.evolve}}
                </td>
                <td>
                    {{row.remarks}}
                </td>
                {{^row.oaEstimateApprove.id}}
                    <shiro:hasPermission name="approve:estimate:oaEstimateApprove:approve">
                        <td>
                            <a href="${ctx}/approve/estimate/oaEstimateApprove/preApprove?estimate.id={{row.id}}">改分申请</a>
                        </td>
                    </shiro:hasPermission>
                {{/row.oaEstimateApprove.id}}
                {{#row.oaEstimateApprove.id}}
                    <shiro:hasPermission name="approve:estimate:oaEstimateApprove:view">
                        <td>
                            <a href="${ctx}/approve/estimate/oaEstimateApprove/form?id={{row.oaEstimateApprove.id}}">审批查看</a>
                        </td>
                    </shiro:hasPermission>
                {{/row.oaEstimateApprove.id}}
            </tr>

            //-->
        </script>


        <div class="control-group">
            <label class="control-label">项目负责人：</label>
            <div class="controls">
                <table id="contentTable1" class="table table-striped table-bordered table-condensed"
                       style="width: 90%;">
                    <thead>
                    <tr>
                        <th class="hide"></th>
                        <th>项目负责人</th>
                        <th>备注信息</th>
                    </tr>
                    </thead>
                    <tbody id="aamsProjectUserList">
                    </tbody>
                </table>
                <script type="text/template" id="aamsProjectUserTpl">//<!--
                            <tr id="aamsProjectUserList{{idx}}" class="my-parent-tr">
                                <td class="hide">
                                    <input id="aamsProjectUserList{{idx}}_id" name="aamsProjectUserList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
                                    <input id="aamsProjectUserList{{idx}}_delFlag" name="aamsProjectUserList[{{idx}}].delFlag" type="hidden" value="0"/>
                                </td>
                                <td style="width:200px">
                                    <sys:treeselect id="aamsProjectUserList{{idx}}_user" name="aamsProjectUserList[{{idx}}].user.id" value="{{row.user.id}}" labelName="aamsProjectUserList{{idx}}.user.name" labelValue="{{row.user.name}}"
                                        title="用户" url="/sys/office/treeData?type=3" cssClass="required readonly-select" allowClear="true" notAllowSelectParent="true" disabled="disabled"/>
                                </td>
                                <td>
                                    {{row.remarks}}
                                </td>
                            </tr>

                            <tr><td colspan="3">
                                <table id="contentTable{{idx}}" class="table table-striped table-bordered table-condensed" style="width: 90%;">
                                    <thead>
                                    <tr>
                                        <th class="hide"></th>
                                        <th>分数</th>
                                        <th>进展情况</th>
                                        <th>备注信息</th>
                                        <c:choose>
                                            <c:when test="${row.oaEstimateApprove.id}">
                                                <shiro:hasPermission name="approve:estimate:oaEstimateApprove:view">
                                                    <th>查看</th>
                                                </shiro:hasPermission>
                                            </c:when>
                                            <c:otherwise>
                                                <shiro:hasPermission name="approve:estimate:oaEstimateApprove:approve">
                                                    <th>申请</th>
                                                </shiro:hasPermission>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                    </thead>
                                    <tbody id="aamsEstimateList{{idx}}">
                                    </tbody>
                            </td></tr>

                            <tr style="border:3px;">
                                <td colspan="4"><hr/></td>
                            </tr>
                            //-->
                </script>
                <script type="text/javascript">
                    var aamsProjectUserRowIdx = 0,
                        aamsProjectUserTpl = $("#aamsProjectUserTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

                    var aamsEstimateTpl = $("#aamsEstimateTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g, "");

                    $(document).ready(function () {
                        var data = ${fns:toJson(aamsProject.aamsProjectUserList)};
                        for (var i = 0; i < data.length; i++) {
                            addParentRow('#aamsProjectUserList', aamsProjectUserRowIdx, aamsProjectUserTpl, data[i]);

                            var subData = data[i].aamsEstimateList;
                            if (subData) {
                                for (var subI = 0; subI < subData.length; subI++) {
                                    var d = subData[subI];
                                    addSubRow('#aamsEstimateList' + aamsProjectUserRowIdx, aamsProjectUserRowIdx, window['aamsEstimateRowIdx' + aamsProjectUserRowIdx], aamsEstimateTpl, d);
                                    window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] = window['aamsEstimateRowIdx' + aamsProjectUserRowIdx] + 1;
                                }
                            }

                            aamsProjectUserRowIdx = aamsProjectUserRowIdx + 1;
                        }
                    });
                </script>
            </div>
        </div>

    </form:form>
</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>考勤生成</title>
    <meta name="decorator" content="default"/>
    <style rel="stylesheet">
        html, body {
            overflow-y: hidden;
        }

        .my-thead-th > th {
            height: 50px;
            z-index: 1000;
        }

        #parent {
            padding-top: -10px;
        }

        #contentTable {
            width: 1800px !important;
        }

        .z-index-top {
            z-index: 10000 !important;
            background-color: #888800 !important;
        }

        .my-text {
            text-shadow: .5px .5px 0px;
            color: #0564a8 !important;
        }

        .check, .check-head {
            text-align: center !important;
            cursor: pointer !important;
            -webkit-touch-callout: none; /* iOS Safari */
            -webkit-user-select: none; /* Chrome/Safari/Opera */
            -khtml-user-select: none; /* Konqueror */
            -moz-user-select: none; /* Firefox */
            -ms-user-select: none; /* Internet Explorer/Edge */
            user-select: none;
            /* Non-prefixed version, currently
           not supported by any browser */
        }

        .check:hover {
            background: rgba(5, 149, 248, 0.22) !important;
        }
    </style>
    <script src="${ctxStatic}/lunar-calendar/lib/LunarCalendar.min.js" type="text/javascript"></script>
    <script src="${ctxStatic}/context-menu/bootstrap-contextmenu.js" type="text/javascript"></script>
    <script src="${ctxStatic}/jQuery-TableHeadFixer/tableHeadFixer.js" type="text/javascript"></script>
    <script type="text/javascript">

        //            农历、节假日显示
        try {
            window.__monthData = LunarCalendar.calendar('${aamsAtten.year}', '${aamsAtten.month}').monthData;
        } catch (e) {
        }

        /**
         * 是否全勤
         */
        function checkQuanQin() {
            var that = this;
            var d = $(that).data();
            var data = {
                id: d.id
            };
            if ($(that).html().trim()) {
                data[d.column] = null;
            } else {
                data[d.column] = 0;
            }

            $.post('${ctx}/atten/aamsAtten/quanQin', data, function (res) {
                if (res && res.isOk) {
                    if ($(that).html().trim()) {
                        $(that).empty();
                        $(that).siblings().filter(".my-score").text(res.currentScore);
                    } else {
                        $(that).empty().append("<i class=\"icon-ok\"></i>");
                        $(that).siblings().filter(".my-score").text(res.currentScore);
                    }
                }
            });
        }

        function onCMItem(context, e) {
            var tdData = $(context).data();
            var label = $(e.target).data("label");
            var data = {
                id: tdData.id
            };
            data[tdData.column] = label;
            $.post('${ctx}/atten/aamsAtten/updateScore', data, function (res) {
                if (res && res.isSuccess) {
                    $(context).empty().text(label);
                    $(context).siblings().filter(".my-score").text(res.currentScore);
                } else {
                    alert('failed')
                }
            });
        }

        $(document).ready(function () {



//            搜索表单，考勤扣分文本框，只能填写负值
            $('#my-score-ipt').keyup(function () {
                var value = $(this).val().trim();
                if (value && parseInt(value.trim()) > 0)
                    $(this).val(-value.trim());
            });


            <shiro:hasPermission name="atten:aamsAtten:edit">
            //  表格单元格  右键请假类型
            $('.check').dblclick(checkQuanQin)
                .contextmenu({
                    target: '#context-menu',
                    onItem: onCMItem
                });

            //  表格表头 右键请假类型
            $('.check-head').dblclick(function () {
                var that = this;
                $.jBox.confirm("此批量操作不可恢复，您确定把此列全部修改了吗？", "提示", function (v, h, f) {
                    if (v == 'ok') {

                        var index = $(that).parent('tr').children('th').index(that)
                        $.each($('#tbody').children('tr').children('td').filter(function (i, item) {
                            return $(item).parents('tr').children('td').index(item) === index;
                        }), function (idex, item) {
                            checkQuanQin.bind(item)();
                        });

                        jBox.tip('正在修改中...', 'info');
                    } else if (v == 'cancel') {
                        jBox.tip('您已取消批量操作', 'info');
                    }
                    return true; //close
                });
            })
            //
                .contextmenu({
                    target: '#context-menu',
                    onItem: function (context, e) {
                        $.jBox.confirm("此操作不可恢复，您确定把此列全部修改了吗？", "提示", function (v, h, f) {
                            if (v == 'ok') {
                                var index = $(context).parent('tr').children('th').index(context)
                                $.each($('#tbody').children('tr').children('td').filter(function (i, item) {
                                    return $(item).parents('tr').children('td').index(item) === index;
                                }), function (idex, item) {
                                    onCMItem(item, e);
                                });
                                jBox.tip('正在修改中...', 'info');
                            } else if (v == 'cancel') {
                                jBox.tip('您已取消批量操作', 'info');
                            }
                            return true; //close
                        });
                    }
                });


            top.$.jBox.messager('双击单元格全勤，右键可选择请假类型', '操作提示');

            </shiro:hasPermission>


            $("#contentTable").tableHeadFixer({"head": true, "left": 3});
            $('#parent').height($(document.body).height() - 120);

            $("#tbody").children("tr")/*.hover(function () {
             $(this.cells).filter(function(i,n){return i>3}).css('background', '#E4E4E4').eq(0).addClass('showDragHandle');
             }, function () {
             $(this.cells).filter(function(i,n){return i>3}).css('background', '').eq(0).removeClass('showDragHandle');
             })*/.click(function () {
//                点击加重当前行
                if (window._preCells) $(window._preCells).removeClass('my-text');
                $(window._preCells = this.cells[1]).addClass('my-text');

            });
            $("#tbody tr td").click(function () {
                $("#tbody tr td").removeClass('my-text');
                $(this).addClass('my-text');
//                $(this).css('background', 'lightgreen!important;');
                //                点击加重当前列头
                var index = $(this).parent('tr').children('td').index(this)
                $.each($('#thead').children('tr').children('th').removeClass('my-text').filter(function (i, item) {
                    return $(item).parents('tr').children('th').index(item) === index;
                }), function (idex, item) {
                    $(this).addClass('my-text');
                });
            });
        })
        ;

        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }

    </script>
</head>
<body>
<div id="context-menu" style="width: 50px;">
    <ul class="dropdown-menu" role="menu">
        <c:forEach items="${fns:getDictList('atten_leave_type')}" var="item">
            <li>
                <a tabindex="-1" data-score="${item.value}" data-label="${item.label}" href="#">${item.label}
                    <c:if test="${item.value < 0}">
                        (${item.value})
                    </c:if>
                </a>
            </li>
        </c:forEach>
    </ul>

</div>

<ul class="nav nav-tabs my-nav-tabs">
    <li class="active"><a href="${ctx}/atten/aamsAtten/">考勤列表</a></li>
    <%--<shiro:hasPermission name="atten:aamsAtten:edit">--%>
    <%--<li><a href="${ctx}/atten/aamsAtten/form">考勤添加</a></li>--%>
    <%--</shiro:hasPermission>--%>
</ul>
<div class="my-list-container">
    <form:form id="searchForm" modelAttribute="aamsAtten" action="${ctx}/atten/aamsAtten/" method="post"
               class="breadcrumb form-search">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <ul class="ul-form">
            <li><label>姓名：</label>
                <shiro:hasPermission name="atten:aamsAtten:edit">
                    <sys:treeselect id="user" name="user.id" value="${aamsAtten.user.id}" labelName="user.name"
                                    labelValue="${aamsAtten.user.name}"
                                    title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                    allowClear="true"
                                    notAllowSelectParent="true"/>
                </shiro:hasPermission>
                <shiro:lacksPermission name="atten:aamsAtten:edit">
                    <sys:treeselect id="user" name="user.id" value="${aamsAtten.user.id}" labelName="user.name"
                                    labelValue="${aamsAtten.user.name}"
                                    title="用户" url="/sys/office/treeData?type=3" cssClass="input-small"
                                    allowClear="true" disabled="disabled"
                                    notAllowSelectParent="true"/>
                </shiro:lacksPermission>
            </li>
            <li><label>年：</label>

                <form:select path="year" class="input-medium">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('sys_score_year')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
            <li><label>月份：</label>
                <form:select path="month" class="input-medium">
                    <form:option value="" label=""/>
                    <form:options items="${fns:getDictList('sys_score_month')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </li>
                <%--<li><label>工作天数：</label>--%>
                <%--<form:input path="workDays" htmlEscape="false" maxlength="2" class="input-medium"/>--%>
                <%--</li>--%>
                <%--<li><label>出勤天数：</label>--%>
                <%--<form:input path="realDays" htmlEscape="false" maxlength="2" class="input-medium"/>--%>
                <%--</li>--%>
                <%--<li><label>缺勤天数：</label>--%>
                <%--<form:input path="queqinDays" htmlEscape="false" maxlength="2" class="input-medium"/>--%>
                <%--</li>--%>
            <li><label>扣分：</label>
                <form:input path="score" type="number" htmlEscape="false" maxlength="2" class="input-medium"
                            id="my-score-ipt"/>
            </li>
            <li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
            <li class="clearfix"></li>
        </ul>
    </form:form>
    <sys:message content="${message}"/>

    <div id="parent">

        <table id="contentTable" class="table table-striped table-bordered">
            <thead id="thead">
            <tr class="my-thead-th">
                <th class="z-index-top">序号</th>
                <th class="z-index-top">&nbsp;姓&nbsp;&nbsp;&nbsp;名&nbsp;</th>
                <%--<th>年</th>--%>
                <%--<th>月份</th>--%>
                <%--<th>天数</th>--%>
                <th class="z-index-top">扣分</th>
                <c:forEach items="${dayWeek}" var="item" varStatus="s">
                    <c:choose>
                        <c:when test="${item.contains('日') || item.contains('六')}">
                            <th class="check-head" style="color:lightgray;"><span
                                    id="check-head-${s.index}"></span><br>${item}</th>
                            <script type="text/javascript">

                                $(function () {
                                    var day = '${item}'.split(' ')[0];
                                    $('#tbody').children('tr').children('td').filter(function (index, item) {
                                        var column = $(item).data('column');
                                        if (column && column == 'day' + day) return item;
                                    }).css('backgroundColor', '#C5C5C5');
                                });
                            </script>
                        </c:when>
                        <c:otherwise>
                            <th class="check-head"><span id="check-head-${s.index}"></span><br>${item}</th>
                        </c:otherwise>

                    </c:choose>
                    <script>
                        var d = window.__monthData[${s.index}];
                        var html = (d.term || d.lunarFestival || d.solarFestival || '') + '<br/>' +
                            //                        (d.worktime == 2 ? '放假' : '') + '<br/>' +
                            d.lunarMonthName + "" + d.lunarDayName;
                        $('#check-head-${s.index}').html(html).tooltip({});
                    </script>
                </c:forEach>
                <%--<th>工作天数</th>--%>
                <%--<th>出勤天数</th>--%>
                <%--<th>缺勤天数</th>--%>
                <%--<shiro:hasPermission name="atten:aamsAtten:edit">--%>
                <%--<th>操作</th>--%>
                <%--</shiro:hasPermission>--%>
            </tr>
            </thead>
            <tbody id="tbody">
            <c:forEach items="${list}" var="aamsAtten">

                <tr>
                    <td style="z-index:100;background-color: lightsteelblue;">
                            ${aamsAtten.seq}
                    </td>
                        <%--<td><a href="${ctx}/atten/aamsAtten/view?id=${aamsAtten.id}">--%>
                        <%--${aamsAtten.id}--%>
                        <%--</a></td>--%>
                    <td style="z-index:100;background-color: lightsteelblue;">
                            ${aamsAtten.user.name}
                    </td>
                        <%--<td>--%>
                        <%--${aamsAtten.year}--%>
                        <%--</td>--%>
                        <%--<td>--%>
                        <%--${aamsAtten.month}--%>
                        <%--</td>--%>
                        <%--<td>--%>
                        <%--${aamsAtten.days}--%>
                        <%--</td>--%>
                    <c:choose>
                        <c:when test="${aamsAtten.score<-10}">
                            <td class="my-score" style="z-index:100;background-color: lightsteelblue;color:red;">
                                    ${aamsAtten.score}
                            </td>
                        </c:when>
                        <c:when test="${aamsAtten.score<-5}">
                            <td class="my-score"
                                style="z-index:100;background-color: lightsteelblue;color:lightsalmon;">
                                    ${aamsAtten.score}
                            </td>
                        </c:when>
                        <c:when test="${aamsAtten.score<0}">
                            <td class="my-score" style="z-index:100;background-color: lightsteelblue;color:#888800;">
                                    ${aamsAtten.score}
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td class="my-score" style="z-index:100;background-color: lightsteelblue;">
                                    ${aamsAtten.score}
                            </td>
                        </c:otherwise>
                    </c:choose>
                    <td class="check" data-column="day1" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day1 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day1}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day2" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day2 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day2}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day3" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day3 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day3}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day4" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day4 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day4}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day5" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day5 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day5}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day6" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day6 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day6}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day7" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day7 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day7}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day8" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day8 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day8}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day9" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day9 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day9}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day10" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day10 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day10}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day11" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day11 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day11}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day12" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day12 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day12}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day13" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day13 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day13}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day14" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day14 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day14}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day15" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day15 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day15}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day16" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day16 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day16}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day17" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day17 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day17}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day18" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day18 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day18}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day19" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day19 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day19}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day20" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day20 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day20}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day21" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day21 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day21}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day22" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day22 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day22}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day23" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day23 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day23}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day24" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day24 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day24}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day25" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day25 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day25}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day26" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day26 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day26}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day27" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day27 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day27}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="check" data-column="day28" data-id="${aamsAtten.id}">
                        <c:choose>
                            <c:when test="${aamsAtten.day28 == '0'}">
                                <i class="icon-ok"></i>
                            </c:when>
                            <c:otherwise>
                                ${aamsAtten.day28}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <c:if test="${dayCount>=29}">
                        <td class="check" data-column="day29" data-id="${aamsAtten.id}">
                            <c:choose>
                                <c:when test="${aamsAtten.day29 == '0'}">
                                    <i class="icon-ok"></i>
                                </c:when>
                                <c:otherwise>
                                    ${aamsAtten.day29}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </c:if>
                    <c:if test="${dayCount>=30}">
                        <td class="check" data-column="day30" data-id="${aamsAtten.id}">
                            <c:choose>
                                <c:when test="${aamsAtten.day30 == '0'}">
                                    <i class="icon-ok"></i>
                                </c:when>
                                <c:otherwise>
                                    ${aamsAtten.day30}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </c:if>
                    <c:if test="${dayCount>=31}">
                        <td class="check" data-column="day31" data-id="${aamsAtten.id}">
                            <c:choose>
                                <c:when test="${aamsAtten.day31 == '0'}">
                                    <i class="icon-ok"></i>
                                </c:when>
                                <c:otherwise>
                                    ${aamsAtten.day31}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </c:if>

                        <%--<td>--%>
                        <%--${aamsAtten.workDays}--%>
                        <%--</td>--%>
                        <%--<td>--%>
                        <%--${aamsAtten.realDays}--%>
                        <%--</td>--%>
                        <%--<td>--%>
                        <%--${aamsAtten.queqinDays}--%>
                        <%--</td>--%>
                        <%--<shiro:hasPermission name="atten:aamsAtten:edit">--%>
                        <%--<td>--%>
                        <%--<a href="${ctx}/atten/aamsAtten/form?id=${aamsAtten.id}">修改</a>--%>
                        <%--<a href="${ctx}/atten/aamsAtten/delete?id=${aamsAtten.id}"--%>
                        <%--onclick="return confirmx('确认要删除该考勤吗？', this.href)">删除</a>--%>
                        <%--</td>--%>
                        <%--</shiro:hasPermission>--%>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
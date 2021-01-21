<?php

// ajax botstrap from /bitrix/modules/main/services/ajax.php
define('NOT_CHECK_FILE_PERMISSIONS', true);
define('PUBLIC_AJAX_MODE', true);
define('NO_KEEP_STATISTIC', 'Y');
define('STOP_STATISTICS', true);

require $_SERVER['DOCUMENT_ROOT'].'/bitrix/modules/main/include/prolog_before.php';

require __DIR__.'/vendor/autoload.php';

ignore_user_abort(true);
set_time_limit(0);

\RodzetaSiteoptions\php\Boot::__hx__init();
\RodzetaSiteoptions\Main::main();

require $_SERVER['DOCUMENT_ROOT'].'/bitrix/modules/main/include/epilog_after.php';

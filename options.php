<?php

namespace Rodzeta\Siteoptions;

if (!defined('B_PROLOG_INCLUDED') || B_PROLOG_INCLUDED !== true) {
	die();
}

use Bitrix\Main\Loader;
use Bitrix\Main\Localization\Loc;
use Bitrix\Main\Application;
use Bitrix\Main\Config\Option;

$app = Application::getInstance();
$context = $app->getContext();
$request = $context->getRequest();

Loc::loadMessages(__FILE__);

$aTabs = [
	[
		'DIV' => 'iblock_props_edit',
		'TAB' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_TAB'),
		'ICON' => 'main_user_edit',
		'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_TAB_TITLE'),
	]
];
$tabControl = new \CAdminTabControl('tabControl', $aTabs);


if ($request->isPost() && check_bitrix_sessid())
{
	if ($request->getPost('save') != '')
	{
		Option::set(ID, 'use_format_csv', $request->getPost('use_format_csv'));
	}
}

$useFormatCsv = Option::get(ID, 'use_format_csv');

?>

<?php $tabControl->begin(); ?>
<form method="post" action="<?= sprintf('%s?mid=%s&lang=%s', $request->getRequestedPage(), urlencode($mid), LANGUAGE_ID); ?>" type="get">
	<?= bitrix_sessid_post(); ?>

	<?php $tabControl->beginNextTab() ?>

	<tr valign="top">
		<td class="adm-detail-content-cell-l" width="50%">
			<?= Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_FORMAT') ?>
		</td>
		<td class="adm-detail-content-cell-r" width="50%">
			<input type="checkbox" name="use_format_csv" value="1" <?= $useFormatCsv? 'checked' : ''?>>
		</td>
	</tr>

	<?php $tabControl->buttons(); ?>

	<input class="adm-btn-save" type="submit" name="save" value="<?= Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_SAVE') ?>">

</form>

<?php $tabControl->end(); ?>

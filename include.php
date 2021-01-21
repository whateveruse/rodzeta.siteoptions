<?php

namespace Rodzeta\Siteoptions;

use Bitrix\Main\Loader;
use Bitrix\Iblock\IblockTable;
use Bitrix\Main\Localization\Loc;
use Bitrix\Main\Config\Option;

const ID = 'rodzeta.siteoptions';
const BASE_URL = '/bitrix/tools/rodzeta.siteoptions/?entity=';

function ExportUrl($entityType, $extraParams = '', $forOutput = '&output=1')
{
	$httpHost = (\CMain::IsHTTPS() ? 'https://' : 'http://') . $_SERVER['HTTP_HOST'];
	$result = $httpHost . BASE_URL . $entityType . $extraParams . $forOutput;

	$useFormatCsv = Option::get(ID, 'use_format_csv');
	if ($useFormatCsv)
	{
		$result .= '&format=1';
	}

	return $result;
}

//foreach (IblockTable::getList(['order' => ['LID' => 'ASC', 'IBLOCK_TYPE_ID' => 'DESC']]) as $iblock) {}
/*
public static function getIblockSections($iblockId)
{
	$resSections = \CIBlockSection::GetTreeList(
		['IBLOCK_ID' => $iblockId],
		['ID', 'NAME', 'DEPTH_LEVEL']
	);
	$result = [];
	while ($section = $resSections->GetNext()) {
		$result[$section['ID']] = str_repeat(' . ', $section['DEPTH_LEVEL'] - 1).$section['NAME'];
	}

	return $result;
}
*/

function HandleChangeIblockTypeAction()
{
	if (empty($_REQUEST['csv_api_change_iblock_type_value'])
			|| empty($_REQUEST['ID']) || !is_array($_REQUEST['ID']))
	{
		return;
	}
	if (!\CModule::IncludeModule('iblock'))
	{
		return;
	}
	foreach ($_REQUEST['ID'] as $iblockId)
	{
		if ((int)$iblockId == 0)
		{
			continue;
		}
		$iblock = new \CIBlock();
		$iblock->Update($iblockId, [
			'IBLOCK_TYPE_ID' => $_REQUEST['csv_api_change_iblock_type_value']
		]);
	}
}

function init()
{
	AddEventHandler('main', 'OnAdminContextMenuShow', function (&$items, &$additional_items) {
		global $APPLICATION;

		$exampleFields = '&select[]=UF_EXAMPLE_FIELD1';
		$sectionExampleFields = '&select[]=UF_TYPE&select[]=UF_CATEGORY&select[]=UF_SIMILAR_PROPS&select[]=UF_NEW_FLAT&select[]=UF_PROP_LINK';
		$currentPageUrl = $APPLICATION->GetCurPage(true);
		$iblockId = $_GET['IBLOCK_ID'];

		switch ($currentPageUrl)
		{
			case '/bitrix/admin/iblock_type_admin.php':
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_TYPES')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_TYPES'),
					   'ONCLICK' => 'window.open("' . ExportUrl('iblock_types') . '");',
				];
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK')
					]),
					'TITLE' =>  Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK'),
					   'ONCLICK' => 'window.open("' . ExportUrl('iblock') . '");',
				];
				break;
			case '/bitrix/admin/user_admin.php':
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_USER')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_USER'),
					'ONCLICK' => 'window.open("' . ExportUrl('user', $exampleFields) . '");',
				];
				break;
			case '/bitrix/admin/userfield_admin.php':
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_USER_FIELD')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_USER_FIELD'),
					'ONCLICK' => 'window.open("' . ExportUrl('user_fields') . '");',
				];
				break;
			case '/bitrix/admin/iblock_section_admin.php':
			case '/bitrix/admin/iblock_element_admin.php':
			case '/bitrix/admin/iblock_list_admin.php':
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_SECTIONS')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_SECTIONS'),
					'ONCLICK' => 'window.open("' . ExportUrl('iblock_sections', '&id=' . $iblockId . $sectionExampleFields) . '");',
				];
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_ELEMENTS')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_ELEMENTS'),
					'ONCLICK' => 'window.open("' . ExportUrl('iblock_elements', '&id=' . $iblockId) . '");',
				];
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_FORM_ELEMENT')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_FORM_ELEMENT'),
					'ONCLICK' => 'window.open("' . ExportUrl('iblock_form_element', '&id=' . $iblockId) . '");',
				];
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_PROPERTIES')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_PROPERTIES'),
					'ONCLICK' => 'window.open("' . ExportUrl('iblock_properties', '&id=' . $iblockId) . '");',
				];

				$url = $APPLICATION->GetCurPageParam('tree=Y', ['tree']);
				list($uri, $params) = explode('?', $url);
				$url = '/bitrix/admin/iblock_section_admin.php?' . $params;
				$additional_items[] = [
					'TEXT' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_SWITCH_IBLOCK_SECTIONS_VIEW')
					]),
					'TITLE' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_SWITCH_IBLOCK_SECTIONS_VIEW'),
					'ONCLICK' => 'location.href="' . $url . '";',
				];
				break;
			default:
				break;
		}
	});

	AddEventHandler('main', 'OnAdminListDisplay', function (&$list) {
		global $APPLICATION;

		$currentPageUrl = $APPLICATION->GetCurPage(true);
		$iblockId = $_GET['IBLOCK_ID'];
		$currentSection = (int)$_GET['find_section_section'];

		$APPLICATION->AddHeadString('
			<script>
				function RodzetaSiteOptions_onClickContextMenuItem(gridId, baseUrl, currentSectionId) {
					var gridObject = BX.Main.gridManager.getById(gridId);
					if (!gridObject.hasOwnProperty("instance")) {
						return;
					}
					var selectedRows = gridObject.instance.getRows().getSelectedIds();
					var l = selectedRows.length;
					var sectionIds = [];
					if (currentSectionId) {
						sectionIds.push("section_id[]=" + currentSectionId);
					}
					for (var i = 0; i < l; i++) {
						var sectionId = selectedRows[i];
						var prefix = sectionId.substr(0, 1);
						if (prefix == "E") {
							continue;
						}
						if (prefix == "S") {
							sectionId = sectionId.substr(1);
						}
						sectionIds.push("section_id[]=" + sectionId);
					}
					window.open(baseUrl + "&" + sectionIds.join("&"));
				}
			</script>
		', true);

		switch ($currentPageUrl)
		{
			case '/bitrix/admin/iblock_section_admin.php':
			case '/bitrix/admin/iblock_list_admin.php':
				$list->arActions['csv_api_export_properties'] = [
					'value' => 'csv_api_export_properties',
					'name' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_MAIN_IBLOCK_PROPERTIES')
					]),
					'action' => 'RodzetaSiteOptions_onClickContextMenuItem("'
							. $list->table_id . '", "'
							. ExportUrl('iblock_properties', '&id=' . $iblockId)
							. '", ' . $currentSection
						. ');',
				];
				break;
			case '/bitrix/admin/iblock_admin.php':
				$resIblockTypes = \CIBlockType::GetList();
				$iblockTypes = [];
				while ($rowIblockType = $resIblockTypes->Fetch())
				{
					if ($iblockType = \CIBlockType::GetByIDLang($rowIblockType['ID'], LANG))
					{
						$iblockTypes[] = [
							'NAME' => $iblockType['NAME'],
							'VALUE' => $rowIblockType['ID'],
						];
					}
				}
				$list->arActions['csv_api_change_iblock_type'] = [
					'value' => 'csv_api_change_iblock_type',
					'lable' => Loc::getMessage('RODZETA_SITEOPTIONS_PREFIX', [
						'#NAME#' => Loc::getMessage('RODZETA_SITEOPTIONS_OPTIONS_CHANGE_IBLOCK_TYPE')
					]),
					'type' => 'select',
					'items' => $iblockTypes,
					'name' => 'csv_api_change_iblock_type_value',
				];
				break;
			default:
				break;
		}
	});

	AddEventHandler('main', 'OnBeforeProlog', function () {
		if ($_SERVER['REQUEST_METHOD'] == 'POST')
		{
			global $APPLICATION;
			switch ($APPLICATION->GetCurPage(true))
			{
				case '/bitrix/admin/iblock_admin.php':
					if (!empty($_REQUEST['csv_api_change_iblock_type_value']))
					{
						HandleChangeIblockTypeAction();
					}
					break;
				default:
					break;
			}
		}
	});
}

init();

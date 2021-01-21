
class IblockTypesIterator extends CDBResultIterator {
    override public function next() {
        super.next();

		var langInfo = CIBlockType.GetByIDLang(current['ID'], 'ru');
		current['LID'] = langInfo['LID'];
		current['NAME'] = langInfo['NAME'];
		current['SECTION_NAME'] = langInfo['SECTION_NAME'];
		current['ELEMENT_NAME'] = langInfo['ELEMENT_NAME'];

        return current;
    }
}

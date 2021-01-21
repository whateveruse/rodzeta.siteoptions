
import php.NativeAssocArray;
import php.NativeArray;
import php.Global.*;

class ExportYml extends ExportCsv
{
	override public function getFileType() {
		return 'yml';
	}

	override public function header() {
        setHeader('Content-type', 'text/xml');

		fwrite(output, convertToUtf8(
'<?xml version="1.0" encoding="' + getOutputEncoding() + '"?>
<yml_catalog date="' + date('Y-m-d H:i:s') + '">
	<shop>
        <name>BestSeller</name>
        <company>Tne Best inc.</company>
        <url>http://best.seller.ru</url>
        <currencies>
            <currency id="RUR" rate="1"/>
        </currencies>
        <categories>
            <category id="1">Бытовая техника</category>
            <category id="10" parentId="1">Мелкая техника для кухни</category>
        </categories>
        <delivery-options>
            <option cost="200" days="1"/>
        </delivery-options>
        <offers>'));
	}

	override public function render() {
        var offer:Xml = Xml.createElement('offer');
        offer.set('id', convertedItem['ID']);

        //TODO!!! mapFields();

        var name = Xml.createElement('name');
        name.addChild(Xml.createPCData(convertedItem['NAME']));
        offer.addChild(name);

        var url = Xml.createElement('url');
        url.addChild(Xml.createPCData(convertedItem['DETAIL_URL']));
        offer.addChild(url);

        var price = Xml.createElement('price');
        price.addChild(Xml.createPCData(convertedItem['cost_curr_value']));
        offer.addChild(price);

        var currencyId = Xml.createElement('currencyId');
        currencyId.addChild(Xml.createPCData(convertedItem['cost_curr']));
        offer.addChild(currencyId);

        /*
            <categoryId>10</categoryId>
            <delivery>true</delivery>
            <delivery-options>
                <option cost="300" days="1" order-before="18"/>
            </delivery-options>
            <param name="Цвет">белый</param>
            <!--weight>3.6</weight>
            <dimensions>20.1/20.551/22.5</dimensions-->
        */

		fwrite(output, convertToUtf8(offer.toString()));
	}

	override public function footer() {
		fwrite(output, convertToUtf8('
        </offers>
'));
        /*
		<gifts>
		    <!-- подарки не из прайс‑листа -->
		</gifts>
		<promos>
		    <!-- промоакции -->
		</promos>
        */
        fwrite(output, convertToUtf8('
	</shop>
</yml_catalog>'));
	}
}
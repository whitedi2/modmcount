﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = ПечатьСпецификация(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;                 
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Элементы.Результат.Редактирование = Истина;
	ФормаПечати.Открыть();

КонецПроцедуры
    

Функция ПечатьСпецификация(ПараметрКоманды)
	Возврат Документы.ЗаказКлиента.ПечатьСпецификация(ПараметрКоманды);
КонецФункции

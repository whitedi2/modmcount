﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ТабДок = ПечатьАктаОбОказанииУслуг(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

Функция ПечатьАктаОбОказанииУслуг(ПараметрКоманды)
	
	Возврат Документы.УЧ_Реализация.ПечатьАктаОбОказанииУслуг(ПараметрКоманды);
	
КонецФункции
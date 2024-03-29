﻿//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТабДок = ПечатьНакладная(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть();   
	
КонецПроцедуры

Функция ПечатьНакладная(ПараметрКоманды)
	
	Если ПараметрКоманды = Тип("Массив") Тогда
		ОбъектыПечати = ПараметрКоманды;
	Иначе
		ОбъектыПечати = Новый Массив;
		ОбъектыПечати.Добавить(ПараметрКоманды);
	КонецЕсли;	
    
	Возврат Документы.УЧ_Возврат.ПечатьНакладная(ПараметрКоманды);
	
КонецФункции
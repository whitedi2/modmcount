﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Счет") = УЧ_Сервер.СчетПоКоду("79.02") Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Организация") = БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "ОрганизацияВн") Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "При перемещении внутри одной организации необходимо печатать ТОРГ-13";
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТабДок = ПечатьТОРГ12НаСервере(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

Функция ПечатьТОРГ12НаСервере(ПараметрКоманды)
	
	Возврат Документы.УЧ_Реализация.ПечатьТОРГ12(ПараметрКоманды);
	
КонецФункции
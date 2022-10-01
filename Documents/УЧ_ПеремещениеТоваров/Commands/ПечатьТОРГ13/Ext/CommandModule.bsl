﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Организация") <> БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "ОрганизацияПолучатель") Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "При перемещении с одной организации на другую необходимо печатать ТОРГ-12";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;	
	
	ТабДок = ПечатьТОРГ13НаСервере(ПараметрКоманды);
		
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.Результат = ТабДок;
	ФормаПечати.Открыть();
	
КонецПроцедуры

Функция ПечатьТОРГ13НаСервере(ПараметрКоманды)
	
	Возврат Документы.УЧ_ПеремещениеТоваров.ПечатьТОРГ13(ПараметрКоманды);
	
КонецФункции
﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	БП = БПСервер.ПоискБП("СогласованиеОбщее", ПараметрКоманды);
	Если НЕ БП = Неопределено Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(БП, "Стартован") Тогда
			Если НЕ БюджетныйНаСервере.ВернутьРеквизит(БП, "ОснованиеЗаблокирован") Тогда
				ОткрытьФорму("Справочник.СогласованиеОбщее.ФормаОбъекта", Новый Структура("Ключ", БП)); 
				Возврат;
			Иначе	
				Предупреждение("Бизнес-процесс согласования уже запущен.");
				Возврат;		
			КонецЕсли;
		Иначе
			ОткрытьФорму(БПСервер.ПолучитьПолноеИмяФормы(БП), Новый Структура("Ключ", БП));
			Возврат;
		КонецЕсли;	
	КонецЕсли;
	
	
	Если Вопрос("После старта процесса согласования изменения в документе станут невозможны. Уверены что хотите стартовать бизнес процесс?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ТекФормаБП = ПолучитьФорму("Справочник.СогласованиеОбщее.Форма.ФормаНовый");
		ТекФормаБП.Объект.Автор 	= БюджетныйНаСервере.ПолучитьПользователя();
		ТекФормаБП.Объект.Описание 	= БюджетныйНаСервере.ВернутьРеквизит(ПараметрКоманды, "Комментарий");
		ТекФормаБП.Объект.Заявка 	= ПараметрКоманды;
		ТекФормаБП.Объект.КонтрольСогласованияОФК = Ложь;
		ТекФормаБП.Элементы.КонтрольСогласованияОФК.Доступность = Истина;
		ТекФормаБП.Объект.ОснованиеЗаблокирован = Истина;
		ТекФормаБП.ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
		ДанныеФормы = ТекФормаБП.Объект;
		//ЗаполнитьНаСервере(ДанныеФормы, ПараметрКоманды);
		КопироватьДанныеФормы(ДанныеФормы, ТекФормаБП.Объект);
		ТекФормаБП.Открыть();
	КонецЕсли;
	
КонецПроцедуры

﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	
	РеквыДока = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды, "Проведен");
	
	Если НЕ РеквыДока.Проведен Тогда
		Сообщить("Создание документов оплаты невозможно, т.к. документ-основание не проведен!");
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("", );
	ТекФорма = ПолучитьФорму("Обработка.Д_ЗаявкиВПлатежки.Форма", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	ТекФорма.Заявка = ПараметрКоманды;
	ТекФорма.Открыть();
КонецПроцедуры

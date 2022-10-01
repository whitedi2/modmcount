﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Тип("Массив") Тогда
		ОбъектыПечати = ПараметрКоманды;
	Иначе
		ОбъектыПечати = Новый Массив;
		ОбъектыПечати.Добавить(ПараметрКоманды);
	КонецЕсли;	
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ОбъектыПечати", ОбъектыПечати);
	ПараметрыПечати.Вставить("ДополнительныеПараметры", Новый Структура("ДополнитьКомплектВнешнимиПечатнымиФормами, Представление", Ложь, "1-Т (Товарно - транспортная накладная)"));
	ПараметрыПечати.Вставить("Форма", ПараметрыВыполненияКоманды.Источник);
	ПараметрыПечати.Вставить("МенеджерПечати", "Документ.УЧ_Реализация");
	ПараметрыПечати.Вставить("Идентификатор", "ТТН");
	
	УправлениеПечатьюРТКлиент.ОбработкаКомандыПечатиТТН(ПараметрыПечати);	
	
КонецПроцедуры

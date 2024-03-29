﻿
&НаКлиенте
Процедура Копировать(Команда)
	ЗакрытьФорму(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КопироватьСЗаменой(Команда)
	ЗакрытьФорму(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Заменить)
	ДанныеЗакрытия = Новый Структура;
	ДанныеЗакрытия.Вставить("МесяцПриемник", МесяцПриемник);
	ДанныеЗакрытия.Вставить("МесяцИсходник", МесяцИсходник);
	ДанныеЗакрытия.Вставить("ТипБюджета", ТипБюджета);
	ДанныеЗакрытия.Вставить("Замена", Заменить);
	Закрыть(ДанныеЗакрытия);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.МесяцИсходник.СписокВыбора.ЗагрузитьЗначения(Параметры.Месяцы.ВыгрузитьЗначения());
	МесяцИсходник = Параметры.ТекМесяц;
	
	Элементы.МесяцПриемник.СписокВыбора.ЗагрузитьЗначения(Параметры.Месяцы.ВыгрузитьЗначения());
	МесяцПриемник = Параметры.ТекМесяц;
	
	СписокБюджетов.Добавить("ОбъемПроизводства", "Бюджет объемов производства");
	СписокБюджетов.Добавить("БюджетСебестоимости", "Бюджет затрат");
	СписокБюджетов.Добавить("ДвижениеСырья", "Бюджет закупок");
	СписокБюджетов.Добавить("Инвестиции", "Бюджет инвестиций");
	СписокБюджетов.Добавить("БюджетПродаж", "Бюджет продаж");
	СписокБюджетов.Добавить("Прочие90", "Бюджет коммерческих расходов (сч 90.3)");
	СписокБюджетов.Добавить("Прочие91", "Бюджет прочих расходов (сч 91)");
	СписокБюджетов.Добавить("ПР", "Бюджет ПР");
	СписокБюджетов.Добавить("Кредиты", "Бюджет кредитов");
	СписокБюджетов.Добавить("Затраты", "Бюджет затрат проектов");
	СписокБюджетов.Добавить("СтатьиОборотки", "Лимиты на оборотку");
	СписокБюджетов.Добавить("РаспределениеПрибыли", "Бюджет распределение прибыли");
КонецПроцедуры






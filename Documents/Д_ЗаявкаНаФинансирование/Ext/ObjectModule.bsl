﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	// регистр ДвиженияПоЗаявкамНаОплату Приход
	//Движения.ДвиженияПоЗаявкамНаОплату.Записывать = Истина;
	//Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
	//	Движение = Движения.ДвиженияПоЗаявкамНаОплату.Добавить();
	//	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//	Движение.Период = Дата;
	//	Движение.Источник = Источник;
	//	Движение.СтатьяДДС = ТекСтрокаТабличнаяЧасть.СтатьяДДС;
	//	Движение.Предприятие = Предприятие;
	//	Движение.ЦФО = ТекСтрокаТабличнаяЧасть.Предприятие;
	//	Движение.Подразделение = Подразделение;
	//	Движение.ПодразделениеЦФО = ТекСтрокаТабличнаяЧасть.Подразделение;
	//	Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
	//	Движение.Контрагент = Контрагент;
	//	Движение.НазначениеПлатежа = НазначениеПлатежа;
	//	Движение.Комментарий = Комментарий;
	//	Движение.ДополнительныйСрез = ТекСтрокаТабличнаяЧасть.ДополнительныйСрез;
	//	Движение.НазначениеПлатежаУчет = НазначениеПлатежаУчет;
	//КонецЦикла;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ТекущаяЗадача = "";
	ТекущийБизнесПроцесс = "";
	ПоказательТипа = "";
	РеестрЗаявок = Неопределено;
	Акцептован = Ложь;
	СуммаОплачено = 0;
	ОчередностьПлатежа =?(ОбъектКопирования.ОчередностьПлатежа = 6 ИЛИ ОбъектКопирования.ОчередностьПлатежа = 0, 5,ОбъектКопирования.ОчередностьПлатежа);
	СтрокиГрафикаБюджета.Очистить();
	
	Статус = Перечисления.СтатусыЗаявокНаОплату.НеСогласовано;
	
	Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
		ТекСтрока.УИДСтроки = "";
	КонецЦикла;
	
	ДокОснование = Неопределено;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	//Исключения = Новый Массив;
	//Исключения.Добавить(Справочники.Предприятия.НайтиПоНаименованию("Зернотрейд", Истина));
	//
	//Для каждого ТекСтрока Из ЗаявкаБезнал Цикл
	//	Если СтатьяСырья(ТекСтрока.СтатьяДДС) И Исключения.Найти(ТекСтрока.ЦФО) = Неопределено Тогда
	//		Если ПустаяСтрока(ТекСтрока.ЗаявкаНаЗакупку) Тогда
	//			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
	//			ЭтотОбъект,
	//			"Не указана заявка на закупку.",
	//			"ЗаявкаБезнал",
	//			ЗаявкаБезнал.Индекс(ТекСтрока) + 1,
	//			"ЗаявкаНаЗакупку",
	//			Отказ);
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	
	//Если РасшифровкаПлатежа Тогда
	//	Если НЕ ТабличнаяЧасть.Итог("Сумма") = Сумма Тогда
	//			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
	//			ЭтотОбъект,
	//			"Сумма расшифровки не соответствует документу.",
	//			"ТабличнаяЧасть",
	//			ТабличнаяЧасть.Количество(),
	//			"Сумма",
	//			Отказ);
	//	КонецЕсли;
	//КонецЕсли;
	
	
	//Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
	//	Если ТекСтрока.Предприятие.УчетПоПодразделениям И НЕ ЗначениеЗаполнено(ТекСтрока.Подразделение) Тогда
	//		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
	//		ЭтотОбъект,
	//		"Не заполнено подразделение!",
	//		"ТабличнаяЧасть",
	//		ТекСтрока.НомерСтроки,
	//		"Подразделение",
	//		Отказ);
	//	КонецЕсли;
	//КонецЦикла;
	
	Если ДополнительныеСвойства.Свойство("Модифицирован") И ДополнительныеСвойства.Модифицирован Тогда
		Если ДатаОплаты < НачалоДня(ТекущаяДата()) Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Дата платежа не может быть меньше текущей.",
			,
			,
			"ДатаОплаты",
			Отказ);
		КонецЕсли;
	КонецЕсли;


	
КонецПроцедуры

Функция СтатьяСырья(ТекСтатья)

	Возврат Ложь;	

КонецФункции // ()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Д_ЗаявкаНаКорректировкуБюджета") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Д_СлужебнаяЗаписка") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Дата, Номер");
		ЦФО = ДанныеЗаполнения.Предприятие;
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) Тогда
			СчетКонтрагента = ДанныеЗаполнения.Контрагент.ОсновнойБанковскийСчет;		
		КонецЕсли;
		
		Сумма = ДанныеЗаполнения.ТабличнаяЧасть.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма");
		СуммаНДС  = ДанныеЗаполнения.ТабличнаяЧасть.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС");
		Если ДанныеЗаполнения.ТабличнаяЧасть.Количество() Тогда
			СтавкаНДС = ДанныеЗаполнения.ТабличнаяЧасть[0].СтавкаНДС;
		КонецЕсли;
		Если ДанныеЗаполнения.Услуги.Количество() Тогда
			СтавкаНДС = ДанныеЗаполнения.Услуги[0].СтавкаНДС;
		КонецЕсли;
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Дата, Номер");
		ЦФО = ДанныеЗаполнения.Предприятие;
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) Тогда
			СчетКонтрагента = ДанныеЗаполнения.Контрагент.ОсновнойБанковскийСчет;		
		КонецЕсли;
		
		Сумма = ДанныеЗаполнения.ТабличнаяЧасть.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма");
		СуммаНДС  = ДанныеЗаполнения.ТабличнаяЧасть.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС");
		Если ДанныеЗаполнения.ТабличнаяЧасть.Количество() Тогда
			СтавкаНДС = ДанныеЗаполнения.ТабличнаяЧасть[0].СтавкаНДС;
		КонецЕсли;
		Если ДанныеЗаполнения.Услуги.Количество() Тогда
			СтавкаНДС = ДанныеЗаполнения.Услуги[0].СтавкаНДС;
		КонецЕсли;
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ВыплатаЗП") Тогда
		ТипИсточника = Перечисления.Д_ИсточникиСредств.Нал;
		ВидОперации = Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику;
		ДокОснование = ДанныеЗаполнения.Ссылка; 
		Контрагент = Справочники.Сотрудники.НайтиПоНаименованию("Сотрудники обобщенное");
		Предприятие = ДанныеЗаполнения.Предприятие;
		ЦФО = ДанныеЗаполнения.Предприятие;
		Подразделение = ДанныеЗаполнения.Подразделение;
		Сумма = ДанныеЗаполнения.СуммаДокумента;
		НазначениеПлатежаУчет = "выплата з/п по ведомости №" + Строка(ДанныеЗаполнения.Номер);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер");
		Предприятие = ДанныеЗаполнения.Организация.Предприятие;
		ЦФО = Предприятие;
		Договор = ДанныеЗаполнения.ДоговорКонтрагента;
		БанковскийСчет = ДанныеЗаполнения.Организация.ОсновнойБанковскийСчет;
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Оплата поставщикам (подрядчикам)", Истина);
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) Тогда
			СчетКонтрагента = ДанныеЗаполнения.Контрагент.ОсновнойБанковскийСчет;		
		КонецЕсли;
		Сумма = ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.Услуги.Итог("Сумма");
		СуммаНДС  = ДанныеЗаполнения.Товары.Итог("СуммаНДС") + ДанныеЗаполнения.Услуги.Итог("СуммаНДС");
		Если ДанныеЗаполнения.Товары.Количество() Тогда
			СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ДанныеЗаполнения.Товары[0].СтавкаНДС);
		КонецЕсли;
		Если ДанныеЗаполнения.Услуги.Количество() Тогда
			СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ДанныеЗаполнения.Услуги[0].СтавкаНДС);
		КонецЕсли;
		Если Не ДанныеЗаполнения.СуммаВключаетНДС Тогда
			Сумма = Сумма + СуммаНДС;		
		КонецЕсли;
		
		//Запрос = Новый Запрос;
		//Запрос.Текст = "ВЫБРАТЬ
		//|	СчетФактураПолученный.Ссылка КАК Ссылка,
		//|	СчетФактураПолученный.НомерВходящегоДокумента КАК Номер,
		//|	СчетФактураПолученный.Дата КАК Дата
		//|ИЗ
		//|	Документ.СчетФактураПолученный КАК СчетФактураПолученный
		//|ГДЕ
		//|	СчетФактураПолученный.ДокументОснование = &ДокументОснование
		//|	И СчетФактураПолученный.Проведен = Истина";
		//
		//Запрос.УстановитьПараметр("ДокументОснование", ДанныеЗаполнения);
		//
		//Результат = Запрос.Выполнить();
		//Выборка = Результат.Выбрать();
		//
		Если ЗначениеЗаполнено(ДанныеЗаполнения.ДатаВходящегоДокумента) Тогда
			НазначениеПлатежа = "Оплата по " + ?(ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги, "акту", " накладной")
			+ " №" + ДанныеЗаполнения.НомерВходящегоДокумента + " от " + Формат(ДанныеЗаполнения.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy");		
		Иначе
			НазначениеПлатежа = "Оплата по " + ?(ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги, "акту", " накладной")
			+ " №" + ДанныеЗаполнения.Номер + " от " + Формат(ДанныеЗаполнения.Дата, "ДФ=dd.MM.yyyy");		
		КонецЕсли;
		НазначениеПлатежаУчет = НазначениеПлатежа;
		
		
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СчетНаОплатуПоставщика") Тогда
		// Заполнение шапки
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер");
		Предприятие = ДанныеЗаполнения.Организация.Предприятие;
		ЦФО = Предприятие;
		Договор = ДанныеЗаполнения.ДоговорКонтрагента;
		БанковскийСчет = ДанныеЗаполнения.Организация.ОсновнойБанковскийСчет;
		СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Оплата поставщикам (подрядчикам)", Истина);
		Если ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент) Тогда
			СчетКонтрагента = ДанныеЗаполнения.Контрагент.ОсновнойБанковскийСчет;		
		КонецЕсли;
		Сумма = ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.УдалитьУслуги.Итог("Сумма");
		СуммаНДС  = ДанныеЗаполнения.Товары.Итог("СуммаНДС") + ДанныеЗаполнения.УдалитьУслуги.Итог("СуммаНДС");
		Если ДанныеЗаполнения.Товары.Количество() Тогда
			СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ДанныеЗаполнения.Товары[0].СтавкаНДС);
		КонецЕсли;
		Если ДанныеЗаполнения.УдалитьУслуги.Количество() Тогда
			СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ДанныеЗаполнения.УдалитьУслуги[0].СтавкаНДС);
		КонецЕсли;
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПлатежноеПоручение") Тогда
		
		СоотвВидовОперация = Новый Соответствие;
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПереводНаДругойСчет, Перечисления.ВидыОперацийПлатежноеПоручение.ОплатаВНХ);
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеЗаработнойПлатыРаботнику, Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику);
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога, Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеНалога);
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеПодотчетномуЛицу, Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику);
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеСотрудникуПоДоговоруПодряда, Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику);
		СоотвВидовОперация.Вставить(Перечисления.ВидыОперацийСписаниеДенежныхСредств.СнятиеНаличных, Перечисления.ВидыОперацийПлатежноеПоручение.СнятиеНаличных);
		
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер");
		Предприятие = ДанныеЗаполнения.Организация.Предприятие;
		ЦФО = Предприятие;
		Договор = ДанныеЗаполнения.ДоговорКонтрагента;
		БанковскийСчет = ДанныеЗаполнения.СчетОрганизации;
		СтатьяДДС = ДанныеЗаполнения.СтатьяДвиженияДенежныхСредств;
		Если Не ЗначениеЗаполнено(СтатьяДДС) Тогда
			СтатьяДДС = Справочники.СтатьиДвиженияДенежныхСредств.НайтиПоНаименованию("Оплата поставщикам (подрядчикам)", Истина);
		КонецЕсли;
		Сумма = ДанныеЗаполнения.СуммаДокумента;
		СуммаНДС  = ДанныеЗаполнения.СуммаНДС;
		Если СуммаНДС Тогда
			СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСБУХУУ().Получить(ДанныеЗаполнения.СтавкаНДС);
		Иначе
			СтавкаНДС = Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС", Истина);	
		КонецЕсли;
		
		ВидОперации = СоотвВидовОперация.Получить(ДанныеЗаполнения.ВидОперации);
		Если Не ЗначениеЗаполнено(ВидОперации) Тогда
			ВидОперации = Перечисления.ВидыОперацийПлатежноеПоручение.Оплата;		
		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_АвансовыйОтчет") Тогда
		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Дата, Номер");
		ДокОснование = ДанныеЗаполнения.Ссылка;
		ЦФО = ДанныеЗаполнения.Предприятие;
		
		ТипИсточника = Перечисления.Д_ИсточникиСредств.Нал;
		ВидОперации = Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику;
		Контрагент = ДанныеЗаполнения.Сотрудник;
		ВыдачаВПодОтчет = Истина;
		СтавкаНДС = Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС", Истина);
		НазначениеПлатежа = "Перечисление в подотчет";
		НазначениеПлатежаУчет = "Перечисление в подотчет";
		
		Сумма = ДанныеЗаполнения.ТабличнаяЧасть.Итог("Сумма");
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
		// Заполнение шапки
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,, "Дата, Номер");
		ДокОснование = ДанныеЗаполнения.Ссылка;
		Предприятие = ДанныеЗаполнения.Организация.Предприятие;
		ЦФО = Предприятие;
		
		ТипИсточника = Перечисления.Д_ИсточникиСредств.Нал;
		ВидОперации = Перечисления.ВидыОперацийПлатежноеПоручение.ПеречислениеСотруднику;
		Контрагент = ДанныеЗаполнения.ФизЛицо;
		ВыдачаВПодОтчет = Истина;
		СтавкаНДС = Справочники.СтавкиНДС.НайтиПоНаименованию("Без НДС", Истина);
		НазначениеПлатежа = "Перечисление в подотчет";
		НазначениеПлатежаУчет = "Перечисление в подотчет";
		
		Сумма = ДанныеЗаполнения.Товары.Итог("Сумма") + ДанныеЗаполнения.Прочее.Итог("Сумма") + ДанныеЗаполнения.Суточные.Итог("Сумма");
		Документы.Д_ЗаявкаНаФинансирование.СформироватьНазначениеПлатежа(ЭтотОбъект, НазначениеПлатежа, Ложь,,Новый Структура("СуммаДокумента", "Сумма"));

	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если НЕ ДополнительныеСвойства.Свойство("Модифицирован") Тогда
		ДополнительныеСвойства.Вставить("Модифицирован", Ложь);
	КонецЕсли;
	
	Если НЕ РасшифровкаПлатежа И НЕ ТабличнаяЧасть.Количество() Тогда
		ТабличнаяЧасть.Очистить();
		НоваяСтрока = ТабличнаяЧасть.Добавить();
		НоваяСтрока.Предприятие = Предприятие;
		НоваяСтрока.СтатьяДДС = СтатьяДДС;
		НоваяСтрока.Сумма = Сумма;
		НоваяСтрока.ВалСумма = СуммаВВалютеПлательщика;
		НоваяСтрока.Подразделение = Подразделение;
	КонецЕсли;
	
	Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.УИДСтроки) Тогда
			ТекСтрока.УИДСтроки = Новый УникальныйИдентификатор;		
		КонецЕсли;	
	КонецЦикла;
	
	//корректируем предыдущие строки бюджета при их наличии
	Если ЗначениеЗаполнено(Ссылка) И ДополнительныеСвойства.Модифицирован ИЛИ ПометкаУдаления Тогда	
		НайденныеСтроки = Ссылка.СтрокиГрафикаБюджета.НайтиСтроки(Новый Структура("Использовать", Истина));
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			Если НЕ ТекСтрока.Использовать ИЛИ Не ЗначениеЗаполнено(ТекСтрока.УИДСтроки) Тогда
				Продолжить;					
			КонецЕсли;
			НаборБюджета = РегистрыСведений.сабГрафикПлатежей.СоздатьНаборЗаписей();
			НаборБюджета.Отбор.УИДСтрокиДокумента.Установить(ТекСтрока.УИДСтроки);
			НаборБюджета.Прочитать();
			Для каждого ТекСтрокаНабораБюджета Из НаборБюджета Цикл
				Если Ссылка.РасшифровкаПлатежа Тогда
					НайденныеСтрокиРасшифровки = Ссылка.ТабличнаяЧасть.НайтиСтроки(Новый Структура("УИДСтроки", ТекСтрока.УИДСтрокиРасшифровки));
					Если НайденныеСтрокиРасшифровки.Количество() Тогда
						ТекСуммаЗаявки = НайденныеСтрокиРасшифровки[0].Сумма;
					Иначе
						ТекСуммаЗаявки = 0;	
					КонецЕсли;
				Иначе
					ТекСуммаЗаявки = Ссылка.Сумма;
				КонецЕсли;
				Если ТекСтрокаНабораБюджета.УИДСтрокиДокумента = ТекСтрока.УИДСтроки Тогда
					Если ТекСтрокаНабораБюджета.Сумма > ТекСуммаЗаявки Тогда
						ТекСтрокаНабораБюджета.Сумма = ТекСтрокаНабораБюджета.Сумма + ТекСуммаЗаявки;
					Иначе
						ТекСтрокаНабораБюджета.Сумма = 0;						
					КонецЕсли;					
				КонецЕсли;
			КонецЦикла;
			НаборБюджета.Записать();
		КонецЦикла;
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Отказ);
	
	УстановитьСтатусСтрокГрафика();
	
	Если ТипЗнч(ДокОснование) = Тип("ДокументСсылка.ПлатежноеПоручение") и ЗначениеЗаполнено(ДокОснование) И НЕ ДокОснование.Заявка = Ссылка Тогда
		ДокОб = ДокОснование.ПолучитьОбъект();
		ДокОб.Заявка = Ссылка;
		
		ДокОб.ТабличнаяЧасть.Очистить();
		
		Для каждого ТекСтрока Из ЭтотОбъект.ТабличнаяЧасть Цикл
			НоваяСтрока = ДокОб.ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			ДокОб.УИДСтроки = ТекСтрока.УИДСтроки;
			НоваяСтрока.УИДСтрокиЗаявки = ТекСтрока.УИДСтроки; 
		КонецЦикла; 
		
		Если НЕ ДокОб.ТабличнаяЧасть.Количество() Тогда
			НоваяСтрока = ДокОб.ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭтотОбъект);
			НоваяСтрока.Предприятие = ЦФО;
			НоваяСтрока.Сумма = Сумма;
		КонецЕсли;
		
		ДокОб.Записать();	
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСтатусСтрокГрафика()
	
	Если ЗначениеЗаполнено(РеестрЗаявок) Тогда
		Возврат;	
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЗаявокНаОплату.Согласовано Тогда
		Точка = Перечисления.Согласование1ТочкиМаршрута.Действие2;
	ИначеЕсли Статус = Перечисления.СтатусыЗаявокНаОплату.НеСогласовано Тогда
		Точка = Перечисления.Согласование1ТочкиМаршрута.Старт;
	ИначеЕсли Статус = Перечисления.СтатусыЗаявокНаОплату.КОплате Тогда
		Точка = Перечисления.Согласование1ТочкиМаршрута.Действие4;
	ИначеЕсли Статус = Перечисления.СтатусыЗаявокНаОплату.Отменено Тогда
		Точка = Перечисления.Согласование1ТочкиМаршрута.Действие1;
	Иначе
		Точка = Перечисления.Согласование1ТочкиМаршрута.Старт;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.сабГрафикПлатежей.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Ссылка);
	НаборЗаписей.Прочитать();
	Для каждого ТекСтрока Из НаборЗаписей Цикл
		ТекСтрока.ТочкаМаршрута = Точка;	
	КонецЦикла;
	НаборЗаписей.Записать();

КонецПроцедуры


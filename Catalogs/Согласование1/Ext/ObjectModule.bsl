﻿Процедура Действие1ПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, Отказ)
	Для каждого Задача Из ФормируемыеСправочники Цикл
        Задача.Заявка = Заявка;
		Задача.Предприятие = Предприятие;
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
    КонецЦикла;
КонецПроцедуры

Процедура Действие1ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	НачатьТранзакцию();
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Предприятие = Предприятие;
	Задача.Наименование = "Отправить Реестр оплат";
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Задача.Исполнитель = Автор;
	
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
	
	УстановитьПривилегированныйРежим(Истина);	
	Если Заявка.Проведен Тогда
		ЗаявкаОбъект = Заявка.ПолучитьОбъект();
		ЗаявкаОбъект.ДополнительныеСвойства.Вставить("БылПроведен", Заявка.Проведен);
		ЗаявкаОбъект.ДополнительныеСвойства.Вставить("СтадияИсполнения", Истина);
		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗафиксироватьТранзакцию();

	
КонецПроцедуры

Процедура Действие2ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка) Экспорт
	
	//возврат; //заглушка на точку
	
	СтандартнаяОбработка = Ложь;
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	Для каждого РольПользователь Из ДопСогласование  Цикл
		Если РольПользователь.Пройден Тогда
			Продолжить;		
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(РольПользователь.СубъектСогласования) Тогда
			Продолжить;		
		КонецЕсли;		
		
		//Если ТочкаМаршрутаБизнесПроцесса = Перечисления.Согласование1ТочкиМаршрута.Действие2 Тогда
		//	Если РольПользователь.РезультирующееСогласование Тогда
		//		Продолжить;			
		//	КонецЕсли;
		//КонецЕсли;
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = РольПользователь.ИДГруппы;
		Иначе
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно И (НЕ ТекИДГруппы = РольПользователь.ИДГруппы  ИЛИ ТекИДГруппы = ПустойИДГруппы) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Предприятие = Предприятие;
		Задача.Наименование = "Согласовать Реестр оплат";
		Задача.СрокВыполнения  = РольПользователь.СрокВыполнения;
		Задача.БизнесПроцесс  = Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		//Сообщить(ТипЗнч(РольПользователь));
		Если ТипЗнч(РольПользователь.СубъектСогласования) = Тип("СправочникСсылка.Пользователи") ИЛИ ТипЗнч(РольПользователь.СубъектСогласования) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			Задача.Исполнитель = РольПользователь.СубъектСогласования;
		Иначе
			//дивизионер и директор закреплены за предприятиями, другие должности нет
			Если РольПользователь.СубъектСогласования = Справочники.Д_Должности.Дивизионер ИЛИ РольПользователь.СубъектСогласования = Справочники.Д_Должности.Директор Тогда
				Задача.Исполнитель = Предприятие[РольПользователь.СубъектСогласования.Наименование];
			Иначе
				Задача.Должность = РольПользователь.СубъектСогласования;			
			КонецЕсли;			
		КонецЕсли;
				
		Задача.Записать();
		ФормируемыеСправочники.Добавить(Задача);
		
		Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования)
			ИЛИ (ТекИДГруппы = ПустойИДГруппы И ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно) Тогда
			Прервать;
		КонецЕсли;	
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОбходЗавершенПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		Если НЕ Пользователь.РезультирующееСогласование Тогда
			Если НЕ Пользователь.Пройден Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура СогласованоДействие3ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие3;
КонецПроцедуры

Процедура СогласованоДействие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие4;
КонецПроцедуры

Процедура Согласование1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого ТекСтрока Из ДопСогласование Цикл
		Если НЕ ТекСтрока.РезультирующееСогласование Тогда
			Если НЕ ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Согласовано Тогда
				Результат = Истина;
				Возврат;
			КонецЕсли;		
		КонецЕсли;
	КонецЦикла; 
	Результат = Ложь;
КонецПроцедуры

Процедура Согласование2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого ТекСтрока Из ДопСогласование Цикл
		//Если БПСервер.ФинДирекция(ТекСтрока.СубъектСогласования) Тогда
			Если НЕ ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Согласовано Тогда
				Результат = Истина;
				Возврат;
			КонецЕсли;		
		//КонецЕсли;
	КонецЦикла; 
	Результат = Ложь;
КонецПроцедуры

Процедура ОбработкаРезультатаСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ОбходЗавершен2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		//Если БПСервер.ФинДирекция(Пользователь.СубъектСогласования) Тогда
			Если НЕ Пользователь.Пройден Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	
		//КонецЕсли;
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		Если НЕ Пользователь.РезультирующееСогласование Тогда
			Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		//Если БПСервер.ФинДирекция(Пользователь.СубъектСогласования) Тогда
			Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	
		//КонецЕсли;
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура Действие5ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	//определяем исполнителя оплаты
	
	//Если Заявка.Самооплата Тогда
	//	Плательщик = Автор;
	//ИначеЕсли Заявка.ТипИсточника = Перечисления.Д_ИсточникиСредств.Прочий ИЛИ Заявка.ТипИсточника = Перечисления.Д_ИсточникиСредств.Казна Тогда
	//Плательщик = Заявка.ИсполнительОплаты;
	//Иначе		
	//	Плательщик = Константы.СотрудникРКО.Получить();	
	//КонецЕсли;
	
	//Для Каждого ТекСтрока Из ДопИсполнение Цикл
	//	Если ТекСтрока.Пройдено И ТекСтрока.Исполнено Тогда
	//		Продолжить;		
	//	КонецЕсли;
	//	
	//	Если ТекСтрока.Исполнитель.Пустая() Тогда
	//		Продолжить;		
	//	КонецЕсли;		
	//	
	//	Задача = Справочники.Задача.СоздатьЗадачу();		
	//	Задача.Заявка = Заявка;
	//	Задача.Дата = ТекущаяДата();
	//	Задача.Предприятие = Предприятие;
	//	//Если ТекСтрока.РольПользователя = "РешениеОбОплате" Или ТекСтрока.РольПользователя = Справочники.РолиИсполнителей.РешениеОбОплате Тогда
	//	//	Задача.Наименование = "Отправить на оплату";
	//	//	Задача.Исполнитель = ТекСтрока.Исполнитель;
	//	//ИначеЕсли ТекСтрока.РольПользователя = "ДопПроверка" Или ТекСтрока.РольПользователя = Справочники.РолиИсполнителей.ДопПроверка Тогда
	//	//	Задача.Наименование = "Проверить корректность предстоящей оплаты";
	//	//	Задача.Исполнитель = ТекСтрока.Исполнитель;
	//	//ИначеЕсли ТекСтрока.РольПользователя = Справочники.РолиИсполнителей.ИсполнительОплаты Или ТекСтрока.РольПользователя = "ИсполнительОплаты" Тогда
	//	//	Задача.Наименование = "Оплатить по заявке";
	//	//	Задача.Исполнитель = ТекСтрока.Исполнитель;
	//	//ИначеЕсли ЗначениеЗаполнено(ТекСтрока.РольПользователя) Или БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Предприятие) Или БПСервер.МеханизмСНесколькимиИсполнителями(Предприятие) Тогда
	//	//	Задача.Наименование = "Отправить на оплату";
	//	//	Задача.Исполнитель = ТекСтрока.Исполнитель;
	//	// Иначе
	//		Задача.Наименование = "Оплатить по заявке";
	//		Задача.Исполнитель = ТекСтрока.Исполнитель;
	//	//КонецЕсли;	
	//	
	//	ТекПлательщик = Задача.Исполнитель;
	//	
	//	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	//	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	//	
	//	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	//	Задача.Описание = Описание;
	//	Задача.РольПользователя = ТекСтрока.РольПользователя;
	//	Если ЗначениеЗаполнено(Заявка.ДатаОплаты) Тогда
	//		Задача.СрокВыполнения = Заявка.ДатаОплаты;
	//	КонецЕсли;
	//	
	//	Задача.Записать();
	//	ФормируемыеСправочники.Добавить(Задача);
	//	Прервать;
	//КонецЦикла; 
	
	СтандартнаяОбработка = Ложь;
	
	НачатьТранзакцию();
	
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	Для каждого РольПользователь Из ДопИсполнение Цикл
		Если РольПользователь.Пройдено Тогда
			Продолжить;		
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(РольПользователь.Исполнитель) Тогда
			Продолжить;		
		КонецЕсли;		
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = РольПользователь.ИДГруппы;
		Иначе
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно И (НЕ ТекИДГруппы = РольПользователь.ИДГруппы  ИЛИ ТекИДГруппы = ПустойИДГруппы) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Предприятие = Предприятие;
		Задача.Наименование = "Оплатить по Реестру";
		Задача.СрокВыполнения  = РольПользователь.СрокВыполнения;
		Задача.БизнесПроцесс  = Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		//Сообщить(ТипЗнч(РольПользователь));
		Если ТипЗнч(РольПользователь.Исполнитель) = Тип("СправочникСсылка.Пользователи") ИЛИ ТипЗнч(РольПользователь.Исполнитель) = Тип("СправочникСсылка.ГруппыПользователей") Тогда
			Задача.Исполнитель = РольПользователь.Исполнитель;
		Иначе
			//дивизионер и директор закреплены за предприятиями, другие должности нет
			Если РольПользователь.Исполнитель = Справочники.Д_Должности.Дивизионер ИЛИ РольПользователь.Исполнитель = Справочники.Д_Должности.Директор Тогда
				Задача.Исполнитель = Предприятие[РольПользователь.Пользователь.Наименование];
			Иначе
				Задача.Должность = РольПользователь.Пользователь;			
			КонецЕсли;			
		КонецЕсли;
		
		Задача.Записать();
		ФормируемыеСправочники.Добавить(Задача);
		
		Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования)
			ИЛИ (ТекИДГруппы = ПустойИДГруппы И ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно) Тогда
			Прервать;
		КонецЕсли;	
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);	
		
		Если НЕ Заявка.Проведен Тогда
			ЗаявкаОбъект = Заявка.ПолучитьОбъект();
			ЗаявкаОбъект.ДополнительныеСвойства.Вставить("БылПроведен", Заявка.Проведен);
			ЗаявкаОбъект.ДополнительныеСвойства.Вставить("СтадияИсполнения", Истина);
			ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
		КонецЕсли;
		
	УстановитьПривилегированныйРежим(Ложь);	
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура Действие3ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка) Экспорт
	
	//обращение № 637 {
	СтандартнаяОбработка = Ложь;
	
	СогласованоДействие3 = Истина;
	Возврат;//заглушка на задачу
	
	//ПользовательОФК = Справочники.Согласование1.ПолучитьСотрудникаОФК(Заявка);
	//Если НЕ ЗначениеЗаполнено(ПользовательОФК) Тогда
	//	СогласованоДействие3 = Истина; //пропускаем контроль ОФК
	//	Возврат;	
	//КонецЕсли;
	//
	//ПредприятиеЗаявки = Заявка.Предприятие;
	//Задача = Справочники.Задача.СоздатьЗадачу();		
	//Задача.Заявка = Заявка;
	//Задача.Дата = ТекущаяДата();
	//Задача.Предприятие = Предприятие;
	//Задача.Наименование = "Проверить заявку на оплату";
	//
	//Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	//Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	//
	//Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	//Задача.Описание = Описание;
	//Задача.Исполнитель = ПользовательОФК;
	//Если ЗначениеЗаполнено(Заявка.ДатаОплаты) Тогда
	//	Задача.СрокВыполнения = Заявка.ДатаОплаты;
	//КонецЕсли;		
	//Задача.Записать();
	//ФормируемыеСправочники.Добавить(Задача);
	//}
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Для каждого ТекПользователь Из ДопСогласование Цикл
		//Если НЕ ТекПользователь.СубъектСогласования = Константы.РуководительУС.Получить() И Не ТекПользователь.РезультирующееСогласование Тогда
		Если ТипЗнч(ТекПользователь.СубъектСогласования) = Тип("СправочникСсылка.Пользователи") Тогда
			ТекПользователь.РезультирующееСогласование = ТекПользователь.СубъектСогласования.РезультирующееСогласование;
		КонецЕсли;
		//КонецЕсли;
	КонецЦикла;
	//Если БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Предприятие) Тогда
	//	Для Каждого ТекСтрокаИсп Из ДопИсполнение Цикл 
	//		Если ТекСтрокаИсп.Исполнитель = Заявка.ИсполнительОплаты И Не ЗначениеЗаполнено(ТекСтрокаИсп.РольПользователя) Тогда
	//			ТекСтрокаИсп.РольПользователя = Справочники.РолиМаршрутовБП.ИсполнительОплаты;//"ИсполнительОплаты";
	//		КонецЕсли;	
	//	КонецЦикла;	
	//КонецЕсли;
	
	Если Не Стартован Тогда
		Стартован = Истина;
	КонецЕсли;

	БПСервер.БППередЗаписьюПередЗаписью1(ЭтотОбъект, Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Предприятие) Тогда
		Если ДопИсполнение.Найти("РешениеОбОплате", "РольПользователя") = Неопределено И ДопИсполнение.Найти(Справочники.РолиИсполнителей.РешениеОбОплате, "РольПользователя") = Неопределено Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не указана роль исполнителя ""Решение об оплате""",
			"Проводки",
			ДопИсполнение.Количество(),
			"Исполнитель",
			Отказ);
		КонецЕсли;
		Если ДопИсполнение.Найти("ДопПроверка", "РольПользователя") = Неопределено И ДопИсполнение.Найти(Справочники.РолиИсполнителей.ДопПроверка, "РольПользователя") = Неопределено Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не указана роль исполнителя ""Дополнительная проверка""",
			"Проводки",
			ДопИсполнение.Количество(),
			"Исполнитель",
			Отказ);
		КонецЕсли;
		Если ДопИсполнение.Найти("ИсполнительОплаты", "РольПользователя") = Неопределено И ДопИсполнение.Найти(Справочники.РолиИсполнителей.ИсполнительОплаты, "РольПользователя") = Неопределено Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не указана роль исполнителя ""Исполнитель оплаты""",
			"Проводки",
			ДопИсполнение.Количество(),
			"Исполнитель",
			Отказ);
		КонецЕсли;	
	ИначеЕсли БПСервер.МеханизмСНесколькимиИсполнителями(Предприятие) Тогда
		Если ДопИсполнение.Найти(Справочники.РолиИсполнителей.ИсполнительОплаты, "РольПользователя") = Неопределено Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не указана роль исполнителя ""Исполнитель оплаты""",
			"Проводки",
			ДопИсполнение.Количество(),
			"Исполнитель",
			Отказ);
		КонецЕсли;	
	Иначе	
		Если ДопИсполнение.Количество() = 0 Тогда
			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
			ЭтотОбъект,
			"Не указан исполнитель оплаты.",
			"Проводки",
			ДопИсполнение.Количество(),
			"Исполнитель",
			Отказ);
		КонецЕсли;
		//Если ДопИсполнение.Количество() > 1 Тогда
		//	сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
		//	ЭтотОбъект,
		//	"Исполнитель оплаты должен быть один.",
		//	"Проводки",
		//	ДопИсполнение.Количество(),
		//	"Исполнитель",
		//	Отказ);
		//КонецЕсли;
		//Если ДопИсполнение.Количество() = 1 Тогда
		//	Если ДопИсполнение[0].Исполнитель <> Заявка.ИсполнительОплаты Тогда
		//		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(
		//		ЭтотОбъект,
		//		"Исполнитель оплаты должен совпадать в табличной части и в документе.",
		//		"ДопИсполнение",
		//		ДопИсполнение.Количество(),
		//		"Исполнитель",
		//		Отказ);
		//	КонецЕсли;
		//КонецЕсли;	
	КонецЕсли;

КонецПроцедуры

Процедура УсловиеНаПроверкуКонтрагентовПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
//{{MRG[ <-> ]
	Если Константы.ИспользоватьБизнесПроцессПроверкиКонтрагентов.Получить() = Ложь Тогда
//}}MRG[ <-> ]
//{{MRG[ <-> ]
//	Если Константы.ПроверкаКонтрагентовПередОплатойЗаявок.Получить() = Ложь Тогда
//}}MRG[ <-> ]
		Результат = Истина;
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Задача.Ссылка КАК Задача
	|ИЗ
	|	Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаОбъектовБД КАК ПроверкаОбъектовБД
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Задача КАК Задача
	|			ПО ПроверкаОбъектовБД.Объект = Задача.Заявка
	|		ПО Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент = ПроверкаОбъектовБД.Объект
	|ГДЕ
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент ССЫЛКА Справочник.Контрагенты
	|	И ЕСТЬNULL(ПроверкаОбъектовБД.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)) <> ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка = &Ссылка
	|	И НЕ Задача.ПометкаУдаления
	|	И НЕ Задача.Выполнена
	|	И ЕСТЬNULL(ПроверкаОбъектовБД.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)) <> ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.ПустаяСсылка)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент <> НЕОПРЕДЕЛЕНО";
	Запрос.УстановитьПараметр("Ссылка", Ссылка.Заявка); 
	РезультатЗапроса = Запрос.Выполнить();
	Результат = РезультатЗапроса.Пустой();
	
КонецПроцедуры

Процедура ПроверкаКонтрагентовПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Задача.Ссылка КАК Задача
	|ИЗ
	|	Документ.Д_ЗаявкаНаОплату.ЗаявкаБезнал КАК Д_ЗаявкаНаОплатуЗаявкаБезнал
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаОбъектовБД КАК ПроверкаОбъектовБД
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Задача КАК Задача
	|			ПО ПроверкаОбъектовБД.Объект = Задача.Заявка
	|		ПО Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент = ПроверкаОбъектовБД.Объект
	|ГДЕ
	|	Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент ССЫЛКА Справочник.Контрагенты
	|	И ЕСТЬNULL(ПроверкаОбъектовБД.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)) <> ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Ссылка = &Ссылка
	|	И НЕ Задача.ПометкаУдаления
	|	И НЕ Задача.Выполнена
	|	И ЕСТЬNULL(ПроверкаОбъектовБД.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.Проверен)) <> ЗНАЧЕНИЕ(Перечисление.СтатусПриПроверкеОбъектовБД.ПустаяСсылка)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент <> ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|	И Д_ЗаявкаНаОплатуЗаявкаБезнал.Контрагент <> НЕОПРЕДЕЛЕНО";
	Запрос.УстановитьПараметр("Ссылка", Ссылка.Заявка); 
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗадачаПоКонтрагенту = Выборка.Задача.ПолучитьОбъект();
		ЗадачаПоКонтрагенту.БизнесПроцесс = Ссылка;
		ЗадачаПоКонтрагенту.ТочкаМаршрута = Перечисления.Согласование1ТочкиМаршрута.ПроверкаКонтрагентов;
		ЗадачаПоКонтрагенту.Записать();
		ФормируемыеСправочники.Добавить(ЗадачаПоКонтрагенту);
	КонецЦикла;	
	
КонецПроцедуры

Процедура ИсполнителиПройденыПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Для Каждого Пользователь Из ДопИсполнение Цикл
		Если НЕ Пользователь.Пройдено Тогда
			Результат = Ложь;
			Возврат;
		КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
	
	//Проверка на полную оплату заявки
	Если Результат И БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Предприятие) Тогда
		Если Заявка.ЗаявкаБезнал.Итог("СуммаДДС") <> Заявка.ЗаявкаБезнал.Итог("УжеОплачено") Тогда
			Результат = Ложь;
			Для Каждого СтрокаИсполнение Из ДопИсполнение Цикл
				СтрокаИсполнение.Пройдено = Ложь;
				СтрокаИсполнение.Исполнено = Ложь;
				СтрокаИсполнение.ПринятоКИсполнению = Ложь;
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ПараметрКоманды = ДанныеЗаполнения.Ссылка;
	РеквизитыЗаявки = БюджетныйНаСервере.ВернутьРеквизиты(ПараметрКоманды, "Комментарий, Предприятие, ДатаОплаты");
	
	Автор = БюджетныйНаСервере.ПолучитьПользователя();
	Описание = РеквизитыЗаявки.Комментарий;
	Заявка = ПараметрКоманды;
	Предприятие = РеквизитыЗаявки.Предприятие;
	ОснованиеЗаблокирован = Истина;
	ОбщийСрок = РеквизитыЗаявки.ДатаОплаты;
	//СтандартныйМаршрут = Истина;
	
	//добавляем финика и директора и учетчика???
	МассивПП = Новый Массив;
	Для каждого ТекСтрока Из ПараметрКоманды.ЗаявкаБезнал Цикл
		
		//если ответственный, то солгасуем у него
		Ответственный = ТекСтрока.Ответственный;
		Если НЕ ПустаяСтрока(Ответственный) Тогда
			Справочники.Согласование1.ДобавитьСтрокуДопСогласование(ЭтотОбъект, Ответственный);
		КонецЕсли;
		//
		
	КонецЦикла;
	
	//При выборе ЦФО Казна (выдача в п/о) в маршруте согласования автоматически добавлять оператора Казны.	
	БПСервер.ДобавитьРецензентовВМаршрут(ЭтотОбъект, "ДопСогласование", ПараметрКоманды.Ссылка);
	БПСервер.ДобавитьРецензентовВМаршрут(ЭтотОбъект, "ДопИсполнение", ПараметрКоманды.Ссылка);
	БПСервер.ДобавитьРецензентовВМаршрут(ЭтотОбъект, "ДопОповещение", ПараметрКоманды.Ссылка);
		
	ТаблицаСогласующих = ЭтотОбъект.ДопСогласование.Выгрузить();
	ТаблицаСогласующих.Сортировать("РезультирующееСогласование, НомерСтроки");
	ЭтотОбъект.ДопСогласование.Загрузить(ТаблицаСогласующих);
	
	//Если ДопСогласование.Количество() Тогда
	//	СтандартныйМаршрут = Истина;	
	//КонецЕсли;
	
	//исполнение
	Справочники.Согласование1.ДобавитьСтрокуДопИсполнение(ЭтотОбъект, ПараметрКоманды);
	
	//ознакомление
	Для каждого ТекОповещение Из ЭтотОбъект.ДопОповещение Цикл
		Справочники.Согласование1.ДобавитьСтрокуДопОзнакомление(ЭтотОбъект, ТекОповещение.Пользователь)	
	КонецЦикла; 
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ТекТочкаМаршрута = БПСервер.ПолучитьТекущуюТочкуМаршрута(Ссылка);
	
	Если Не ЗначениеЗаполнено(ТекТочкаМаршрута) И Не Завершен Тогда //старт процесса
		Действие2ПередСозданиемЗадач(Перечисления.Согласование1ТочкиМаршрута.Действие2, Новый Массив, Истина);
	КонецЕсли;

	БПСервер.БППриЗаписиПриЗаписи(ЭтотОбъект, Ложь);
	
КонецПроцедуры








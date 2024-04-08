﻿
#Область СозданиеЗадач

Процедура ОбходЗавершенПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		Если НЕ Пользователь.Пройден Тогда
			Результат = Ложь;
			Возврат;
		КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Для каждого Пользователь Из ДопСогласование Цикл
		Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
			Результат = Ложь;
			Возврат;
			КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура СогласованоДействие4ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие4;
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Заявка.Проведен Тогда
		Заявка.ПолучитьОбъект().Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопИсполнение Цикл
		Если Пользователь.Пройдено И НЕ Пользователь.Исполнено Тогда
			Результат = Ложь;
			Возврат;
		КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
	Для каждого ТекОповешаемый Из ДопОповещение Цикл
		ТекОповешаемый.Оповещен = Истина;	
	КонецЦикла; 
КонецПроцедуры

Процедура Условие3ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопИсполнение Цикл
		Если НЕ Пользователь.Пройдено Тогда
			Результат = Ложь;
			Возврат;
		КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура СтартПередСтартом(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	МассивУчетчиков = Новый Массив;
	
	Для каждого ТекСтрока Из ДопОповещение Цикл
		Если ТекСтрока.СразуПослеСтарта И НЕ ТекСтрока.Пользователь.Пустая() И МассивУчетчиков.Найти(ТекСтрока.Пользователь) = Неопределено Тогда
			МассивУчетчиков.Добавить(ТекСтрока.Пользователь);	
		КонецЕсли;
	КонецЦикла; 
	
	Если МассивУчетчиков.Количество() Тогда		
		БПСервер.СоздатьОповещение(МассивУчетчиков, ?(ДопСогласование.Количество(), "Ознакомиться с предварительным запуском ", "Ознакомиться с предварительным запуском ") + Строка(Заявка.Метаданные().Синоним), "Ознакомиться с предварительным запуском", Заявка,,"системное");
	КонецЕсли;
	
КонецПроцедуры

Процедура Действие1ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Задача = БПСервер.НоваяЗадача(
		Автор, 
		"Доработать", 
		Ссылка, 
		ТочкаМаршрутаБизнесПроцесса);
	
	ФормируемыеЗадачи.Добавить(Задача);
	
	
	//////////////////// закоментировал. Было непонятно, зачем это
	//МассивИсключений = ТипыИсключенные();
	//Если МассивИсключений.Найти(ТипЗнч(Заявка)) = Неопределено Тогда
	//	
	//	Заявка.ПолучитьОбъект().Записать();
	//	
	//КонецЕсли;
	
КонецПроцедуры

Процедура Действие2ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	Для каждого РольПользователь Из ДопСогласование  Цикл
		Если РольПользователь.Пройден ИЛИ РольПользователь.СубъектСогласования.Пустая() Тогда
			Продолжить;		
		КонецЕсли;
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = РольПользователь.ИДГруппы;
		Иначе
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
				Если НЕ ТекИДГруппы = РольПользователь.ИДГруппы ИЛИ ТекИДГруппы = ПустойИДГруппы Тогда
					Прервать;
				КонецЕсли;
			ИначеЕсли ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(РольПользователь.РольПользователя) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(РольПользователь.РольПользователя.НаименованиеЗадачи) Тогда
			НаименованиеЗадачи = РольПользователь.РольПользователя.НаименованиеЗадачи + " " + Заявка.Метаданные().Синоним
		Иначе
			НаименованиеЗадачи = "Согласовать";
		КонецЕсли;
		
		Задача = БПСервер.НоваяЗадача(
		РольПользователь.СубъектСогласования, 
		НаименованиеЗадачи, 
		Ссылка, 
		ТочкаМаршрутаБизнесПроцесса,,,,,
		РольПользователь);
		ФормируемыеЗадачи.Добавить(Задача);
		
		//Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования)
		//	ИЛИ (ТекИДГруппы = ПустойИДГруппы И ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно) Тогда
		//	Прервать;
		//КонецЕсли;	
	КонецЦикла;

	//закоментил Д1 07.07.2015 хз зачем было нужно
	//МассивИсключений = ТипыИсключенные();
	//Если МассивИсключений.Найти(ТипЗнч(Заявка)) = Неопределено Тогда
	//	Заявка.ПолучитьОбъект().Записать();
	//КонецЕсли;

	//Если ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
	//	УчетчикПредприятия = БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(Заявка.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик);	
	//	УчетчикВСети = БПСервер.ПользовательВСети(УчетчикПредприятия);	
	//	// переадресация на учетчика офиса
	//	Если ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", УчетчикПредприятия)).Количество() Тогда
	//		МассивПеренаправляемыхЗадач = Новый Массив;
	//		Если Не УчетчикВСети Тогда
	//			ЗадачаУч = ПолучитьЗадачуУчетчикаПредприятия(Ссылка, УчетчикПредприятия);
	//			Если ЗначениеЗаполнено(ЗадачаУч) Тогда
	//				МассивПеренаправляемыхЗадач.Добавить(ЗадачаУч);
	//			КонецЕсли;	
	//		КонецЕсли;
	//		Если МассивПеренаправляемыхЗадач.Количество() Тогда
	//			УчетчикОфиса = Константы.БП_УчетчикОфиса.Получить();
	//			СтруктураПараметров = Новый Структура("Комментарий, НовыйИсполнитель", "Пользователь "+ Строка(УчетчикПредприятия) +" будет заменен на пользователя " + Строка(УчетчикОфиса) + " в связи с его отсутствием.", УчетчикОфиса);
	//			Результат = БПСервер.ПеренаправитьСправочники(МассивПеренаправляемыхЗадач, СтруктураПараметров, Ложь);
	//		КонецЕсли;	
	//	КонецЕсли;	
	//КонецЕсли;
	
КонецПроцедуры

Процедура Действие3ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	
	Для каждого ТекСтрока Из ДопИсполнение Цикл
		Если ТекСтрока.Пройдено ИЛИ ТекСтрока.Исполнитель.Пустая() Тогда
			Продолжить;		
		КонецЕсли;
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = ТекСтрока.ИДГруппы;
		Иначе
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
				Если НЕ ТекИДГруппы = ТекСтрока.ИДГруппы ИЛИ ТекИДГруппы = ПустойИДГруппы Тогда
					Прервать;
				КонецЕсли;
			ИначеЕсли ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;

		
		Если ТипЗнч(ТекСтрока.РольПользователя) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(ТекСтрока.РольПользователя.НаименованиеЗадачи) Тогда
			НаименованиеЗадачи = ?(ТекСтрока.ПринятоКИсполнению, "Исполнить", "Принять к исполнению") + ": " + ТекСтрока.РольПользователя.НаименованиеЗадачи + " " + Заявка.Метаданные().Синоним;
		Иначе
			НаименованиеЗадачи = ?(ТекСтрока.ПринятоКИсполнению, "Исполнить", "Принять к исполнению") + ?(ЗначениеЗаполнено(ТекСтрока.НаименованиеЗадачи), ": " + ТекСтрока.НаименованиеЗадачи, "");
		КонецЕсли;
		
		
		Задача = БПСервер.НоваяЗадача(
		ТекСтрока.Исполнитель, 
		НаименованиеЗадачи, 
		Ссылка, 
		ТочкаМаршрутаБизнесПроцесса,
		,
		ТекСтрока.Предприятие, ТекСтрока.ДокументОбязательныйКПрикреплению,,
		ТекСтрока);
		
		ФормируемыеЗадачи.Добавить(Задача);
		
		//Если ВариантИсполнения = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно Тогда
		//	Прервать;
		//КонецЕсли;	
	КонецЦикла;
	
	//закоментил Д1 07.07.2015 хз зачем было нужно
	//МассивИсключений = ТипыИсключенные();
	//Если МассивИсключений.Найти(ТипЗнч(Заявка)) = Неопределено Тогда
	//	//Заявка.ПолучитьОбъект().Записать();
	//КонецЕсли;
	
	//шлем оповещение автору о нахождении заявки на исполнении
	Если КонтролироватьИсполнение И ДопИсполнение.Количество() Тогда
		
		БПСервер.СоздатьОповещение(Автор, "Документ " + Строка(Заявка) + " согласован и поступил на исполнение пользователю " + Строка(ТекСтрока.Исполнитель) + ".", "Согласовано: " + Строка(Заявка), Заявка);
		
	КонецЕсли;
	
	//создаем e-mail сообщение или создаем задачу руководителю проекта
	ТекРассылка = ДопРассылка;	
	Кому = "";
	Для каждого ТекРесп Из ДопРассылка Цикл
		Если Не ПустаяСтрока(ТекРесп.EMail) Тогда
			Кому = Кому + ТекРесп.EMail + "; ";	
		КонецЕсли;
	КонецЦикла;
	
	//Если НЕ Кому = "" Тогда
	//	Кому = Лев(Кому, СтрДлина(Кому) -2);
	//	ОтправитьПисьмоРуководителю(Кому);
	//КонецЕсли;
	
	Попытка
		
		Если НЕ Заявка.Проведен И НЕ Заявка.ПометкаУдаления Тогда
			УстановитьПривилегированныйРежим(Истина);
			ЗаявкаОбъект = Заявка.ПолучитьОбъект();
			ЗаявкаОбъект.ДополнительныеСвойства.Вставить("БылПроведен", Заявка.Проведен);
			ЗаявкаОбъект.ДополнительныеСвойства.Вставить("СтадияИсполнения", Истина);
			ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	
КонецПроцедуры

Процедура Действие4ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	СтандартнаяОбработка = Ложь;
	
	МассивУчетчиков = Новый Массив;
	
	Для каждого ТекСтрока Из ДопОповещение Цикл
		Если ТекСтрока.СразуПослеСтарта И НЕ ТекСтрока.Пользователь.Пустая() И МассивУчетчиков.Найти(ТекСтрока.Пользователь) = Неопределено Тогда
			МассивУчетчиков.Добавить(ТекСтрока.Пользователь);	
		КонецЕсли;
	КонецЦикла; 
	
	Если ПодтверждениеОзнакомления Тогда
		Для каждого ТекУчетчик Из МассивУчетчиков Цикл
			Задача = БПСервер.НоваяЗадача(
			ТекУчетчик, 
			?(ДопСогласование.Количество(), "Ознакомиться с предварительным запуском ", "Ознакомиться с предварительным запуском "), 
			Ссылка, 
			ТочкаМаршрутаБизнесПроцесса);
			ФормируемыеЗадачи.Добавить(Задача);
		КонецЦикла;
	ИначеЕсли МассивУчетчиков.Количество() Тогда		
		БПСервер.СоздатьОповещение(МассивУчетчиков, "Запущено согласование документа " + Строка(Заявка) + " пользователем " + Строка(ПараметрыСеанса.ТекущийПользователь) + ". Документ доступен в форме списка.", "Запущено согласование документа " + Строка(Заявка), Заявка,,"система");
	КонецЕсли;
	
КонецПроцедуры

Процедура Действие6ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
		
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	
	Для каждого ТекСтрока Из ДопОповещение Цикл
		
		Если ТекСтрока.Оповещен ИЛИ ТекСтрока.Пользователь.Пустая() Тогда
			Продолжить;		
		КонецЕсли;
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = ТекСтрока.ИДГруппы;
		Иначе
			
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
				
				Если НЕ ТекИДГруппы = ТекСтрока.ИДГруппы ИЛИ ТекИДГруппы = ПустойИДГруппы Тогда
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования) Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
				
		Задача = БПСервер.НоваяЗадача(
		ТекСтрока.Пользователь, 
		"Ознакомиться с результатом согласования и исполнения", 
		Ссылка, 
		ТочкаМаршрутаБизнесПроцесса);
		
		ФормируемыеЗадачи.Добавить(Задача);	
	КонецЦикла;

КонецПроцедуры

Процедура Действие5ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	//Если Не СоздаватьЗадачуОзнакомленияАвтору(Заявка) Тогда //если последний исполнитель/согласователь - автор, то не создавать задачу ознакомления
	//	СогласованоДействие4 = Истина;
	//	Возврат;
	//КонецЕсли; 
	
	//Создаем Справочники ознакомления
	
	СтандартнаяОбработка = Ложь;
	
	ПустойИДГруппы = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	ТекИДГруппы = Неопределено;
	Для каждого РольПользователь Из ДопСогласование  Цикл
		Если РольПользователь.Пройден Тогда
			Продолжить;		
		КонецЕсли;
		
		Если ТекИДГруппы = Неопределено Тогда
			ТекИДГруппы = РольПользователь.ИДГруппы;
		Иначе
			Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно Тогда
				Если НЕ ТекИДГруппы = РольПользователь.ИДГруппы ИЛИ ТекИДГруппы = ПустойИДГруппы Тогда
					Прервать;
				КонецЕсли;
			ИначеЕсли ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(РольПользователь.РольПользователя) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(РольПользователь.РольПользователя.НаименованиеЗадачи) Тогда
			НаименованиеЗадачи = РольПользователь.РольПользователя.НаименованиеЗадачи + " " + Заявка.Метаданные().Синоним
		Иначе
			НаименованиеЗадачи = "Ознакомиться";
		КонецЕсли;
		
		Задача = БПСервер.НоваяЗадача(
		РольПользователь.СубъектСогласования, 
		НаименованиеЗадачи, 
		Ссылка, 
		ТочкаМаршрутаБизнесПроцесса,,,,,
		РольПользователь);
		ФормируемыеЗадачи.Добавить(Задача);
		
		//Если ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Последовательно ИЛИ Не ЗначениеЗаполнено(ВариантСогласования)
		//	ИЛИ (ТекИДГруппы = ПустойИДГруппы И ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно) Тогда
		//	Прервать;
		//КонецЕсли;	
	КонецЦикла;
	
	//Задача = Справочники.Задача.СоздатьЭлемент();		
	//Задача.Заявка = Заявка;
	//Задача.Дата = ТекущаяДата();
	//Задача.Предприятие = Предприятие;
	//Задача.Наименование = "Ознакомиться";
	//
	//
	//Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	//Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	//
	//Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	//Задача.Описание = Описание;
	//Задача.Исполнитель = Автор;
	//
	//Задача.Записать();
	//ФормируемыеЗадачи.Добавить(Задача);
	
	
	//БПСервер.ОповещаемОСЗ(ЗАявка, "Утверждение", Адресаты.ВыгрузитьКолонку("СубъектСогласования"));


КонецПроцедуры

#КонецОбласти 

#Область Служебные
Функция ТипыИсключенные()
	
	МассивИсключений = Новый Массив;
	//МассивИсключений.Добавить(Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку"));
	//МассивИсключений.Добавить(Тип("ДокументСсылка.УЧ_Стр_ДоговорДолевогоУчастия"));
	//МассивИсключений.Добавить(Тип("ДокументСсылка.УЧ_Стр_ДоговорДолевогоУчастия"));
	Возврат МассивИсключений;	

КонецФункции // ()

Процедура ОтправитьПисьмоРуководителю(Кому)
	//Тема = "Новое согласование в электронном документообороте: " + Строка(Заявка);
	//Содержание = "Данная заявка была согласована в системе электронного документооборота:
	//|" + Символы.ПС + Строка(Заявка);
	//
	//
	//Рецензенты = Символы.ПС + Символы.ПС + "Заявку согласовали:" + Символы.ПС;
	//
	//Для каждого ТекСтрока Из ДопСогласование Цикл
	//	Рецензенты = Рецензенты + Строка(ТекСтрока.Пользователь) + ?(ПустаяСтрока(ТекСтрока.Пользователь.Должность), "", " (" + Строка(ТекСтрока.Пользователь.Должность) + ")") +
	//	?(ПустаяСтрока(ТекСтрока.Комментарии), "", " (" + ТекСтрока.Комментарии + ")") + Символы.ПС;	
	//КонецЦикла; 
	//
	//Содержание = Содержание + Рецензенты;			
	//
	//Кому = Кому;
	//
	//Подпись = НСтр("ru = 'Сообщение автоматически отправлено из программы 1С:Корпоративный учет.'");
	//Подпись = Подпись + Символы.ПС;
	//Подпись = Подпись + НСтр("ru = 'Основание: '") + ПолучитьНавигационнуюСсылкуИнформационнойБазы() + "#" + ПолучитьНавигационнуюСсылку(Заявка);
	//
	//Содержание = Содержание + Символы.ПС + Символы.ПС + Подпись;
	//
	//ТабДок = Новый ТабличныйДокумент;
	//МассивЗаявок = Новый Массив;
	//МассивЗаявок.Добавить(Заявка);
	//
	//ИмяДока = Заявка.ПолучитьОбъект().Метаданные().Имя;
	//
	//Попытка
	//	Документы[ИмяДока].Печать(ТабДок, МассивЗаявок);
	//Исключение
	//	Справочники[ИмяДока].Печать(ТабДок, МассивЗаявок);
	//КонецПопытки;
	//
	//ТабДок.ОтображатьСетку = Ложь;
	//ТабДок.Защита = Ложь;
	//ТабДок.ТолькоПросмотр = Истина;
	//ТабДок.ОтображатьЗаголовки = Истина;
	//ТабДок.АвтоМасштаб = Истина;
	//Попытка
	//	//нужно чтобы на сервере уже существовал данный файл, иначе отправка на эмейл будет зависать!
	//	ТабДок.Записать("C:\1cTemp\tempSales.xls", ТипФайлаТабличногоДокумента.XLS);		
	//Исключение
	//	
	//КонецПопытки; 
	//
	//
	//ТекФайл = Новый Файл("C:\1cTemp\tempSales.xls");
	//
	//Пока  НЕ ТекФайл.Существует() Цикл
	//	//ОбработкаПрерыванияПользователя();
	//КонецЦикла;
	//
	//УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	//
	//СписокФайлов = Новый ТаблицаЗначений;
	//СписокФайлов.Колонки.Добавить("ИмяФайла");
	//СписокФайлов.Колонки.Добавить("ПолноеИмя");
	//НоваяСтрока = СписокФайлов.Добавить();
	//НоваяСтрока.ИмяФайла = Строка(Заявка) + ".xls";
	//НоваяСтрока.ПолноеИмя = "C:\1cTemp\tempSales.xls";
	//
	//УправлениеЭлектроннойПочтой.ОтправитьПоЭлектроннойПочте(
	//УчетнаяЗапись,
	//Кому,
	//Тема,
	//Содержание,
	//ВажностьИнтернетПочтовогоСообщения.Обычная,
	//СписокФайлов,
	//Ложь);
	
КонецПроцедуры
	
Процедура ДозаполнитьРолиСогласователей()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	РолиИсполнителей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РолиИсполнителей КАК РолиИсполнителей
	|ГДЕ
	|	РолиИсполнителей.РольПоУмолчанию = ИСТИНА";
	
	Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Для каждого ТекСтрока Из ДопСогласование Цикл
			Если Не ЗначениеЗаполнено(ТекСтрока.РольПользователя) Тогда
				ТекСтрока.РольПользователя = Выборка.Ссылка;
			КонецЕсли;
		КонецЦикла; 	
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьЗадачуУчетчикаПредприятия(БП, Учетчик)
	
	ТекЗадача = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БП", БП);
	Запрос.УстановитьПараметр("Исполнитель", Учетчик);
	Запрос.УстановитьПараметр("ТочкаМаршрута", Перечисления.СогласованиеОбщееТочкиМаршрута.Действие2);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.Ссылка
	               |ИЗ
	               |	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БП
	               |	И Задача.Исполнитель = &Исполнитель
	               |	И Задача.ТочкаМаршрута = &ТочкаМаршрута
	               |	И Задача.ПометкаУдаления = ЛОЖЬ";
				   
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекЗадача = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат ТекЗадача;
	
КонецФункции


#КонецОбласти 

#Область Общие

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;		
	
	МассивПустых = Новый Массив;
	ЕслиПустыеРолиСогласователя = Ложь;
	Для каждого ТекСтрока Из ДопСогласование Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.СубъектСогласования) Тогда
			МассивПустых.Добавить(ТекСтрока);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ТекСтрока.РольПользователя) Тогда
			ЕслиПустыеРолиСогласователя = Истина;		
		КонецЕсли;
	КонецЦикла;
	Для каждого ТекПустая Из МассивПустых Цикл
		ДопСогласование.Удалить(ТекПустая);
	КонецЦикла;
	
	МассивПустых = Новый Массив;
	Для каждого ТекСтрока Из ДопОповещение Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.Пользователь) Тогда
			МассивПустых.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Для каждого ТекПустая Из МассивПустых Цикл
		ДопОповещение.Удалить(ТекПустая);
	КонецЦикла;
	
	МассивПустых = Новый Массив;
	Для каждого ТекСтрока Из ДопИсполнение Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.Исполнитель) Тогда
			МассивПустых.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Для каждого ТекПустая Из МассивПустых Цикл
		ДопИсполнение.Удалить(ТекПустая);
	КонецЦикла;
	
	МассивПустых = Новый Массив;
	Для каждого ТекСтрока Из ДоступнаПользователям Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.Пользователь) Тогда
			МассивПустых.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	Для каждого ТекПустая Из МассивПустых Цикл
		ДоступнаПользователям.Удалить(ТекПустая);
	КонецЦикла;
	
	Если ЕслиПустыеРолиСогласователя Тогда
		ДозаполнитьРолиСогласователей();
	КонецЕсли;
	
	Если Не Стартован Тогда
		Стартован = Истина;
	КонецЕсли;
	
	БПСервер.БППередЗаписьюПередЗаписью1(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработкаЗаполнения
	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если  ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Заявка = ДанныеЗаполнения.Ссылка;
	ВидСЗ = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Ссылка, "ВидСЗ");
	
	Автор = БюджетныйНаСервере.ПолучитьПользователя();
	Описание = БюджетныйНаСервере.ВернутьРеквизит(ДанныеЗаполнения.Ссылка, "Комментарий");
	ОснованиеЗаблокирован = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.Д_СлужебнаяЗаписка") Тогда
		ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаКорректировкуБюджета") Тогда
		ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
		ЗаполнитьНаСервереЗаявкаНаКорректировкуБюджета(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаКадровоеДвижение") Тогда
		ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
		ЗаполнитьНаСервереЗаявкаНаКадровоеДвижение(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
		ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
		Описание = Строка(ДанныеЗаполнения.Контрагент) + ?(ЗначениеЗаполнено(ДанныеЗаполнения.НазначениеПлатежаУчет), " (" + ДанныеЗаполнения.НазначениеПлатежаУчет + ")", "");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаАвансовыйОтчет") Тогда
		ЗаполнитьНаСервереАвансовыйОтчет(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
	Иначе
		ЗаполнитьНаСервере(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереАвансовыйОтчет(ТекОбъект, ТекОснование, ТолькоИсполнителей = Ложь) Экспорт
	
	НоваяСтрока = ТекОбъект.ДопИсполнение.Добавить();
	НоваяСтрока.Исполнитель = ТекОснование.Кассир;
	
	//добавляем в согласование фиников предприятий, на которых вешаются затраты
	Для каждого ТекСтрока Из ТекОснование.Затраты Цикл
		
		Если НЕ ТолькоИсполнителей Тогда
			БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, ТекСтрока.Предприятие, ТекОснование.Дата);
			БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, ТекСтрока.Предприятие, ТекОснование.Дата);
		КонецЕсли;
		БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, ТекСтрока.Предприятие, ТекОснование.Дата);
		
	КонецЦикла; 

КонецПроцедуры

Процедура ЗаполнитьНаСервереЗаявкаНаКорректировкуБюджета(ТекОбъект, ТекОснование)
	
	//заполняем стандартным маршрутом
	ТекОбъект.СтандартныйМаршрут = Истина;
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, , ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, , ТекОснование.Дата);
	Если ТипЗнч(ТекОснование.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаКорректировкуБюджета") Тогда
		БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "Адресаты", ТекОснование.Ссылка, , ТекОснование.Дата);
	Иначе	
		БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, , ТекОснование.Дата);
	КонецЕсли;	
			
	//добавляем начальника бюджетного отдела
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	МаршрутыДвиженияЗаявок.КонтрольОФК
	//               |ИЗ
	//               |	Справочник.МаршрутыДвиженияЗаявок КАК МаршрутыДвиженияЗаявок
	//               |ГДЕ
	//               |	МаршрутыДвиженияЗаявок.Ссылка В(&Ссылка)";
	//
	//Запрос.УстановитьПараметр("Ссылка", ТекОбъект.ДопСогласование.Выгрузить().ВыгрузитьКолонку("МаршрутДвижения"));
	//
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	//
	//Если Выборка.Количество() Тогда
	//	НачальникБО = Справочники.Пользователи.ПустаяСсылка();
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = "ВЫБРАТЬ
	//	               |	Пользователи.Ссылка
	//	               |ИЗ
	//	               |	Справочник.Пользователи КАК Пользователи
	//	               |ГДЕ
	//	               |	Пользователи.ПометкаУдаления = ЛОЖЬ
	//	               |	И Пользователи.Должность = &Должность";
	//	Запрос.УстановитьПараметр("Должность", Справочники.Д_Должности.НайтиПоНаименованию("Начальник БО"));
	//	РезультатНачБО = Запрос.Выполнить();
	//	ВыборкаНачБО = РезультатНачБО.Выбрать();
	//	Пока ВыборкаНачБО.Следующий() Цикл
	//		Если ЗначениеЗаполнено(ВыборкаНачБО.Ссылка) Тогда
	//			НачальникБО = ВыборкаНачБО.Ссылка;
	//			Прервать
	//		КонецЕсли;
	//	КонецЦикла;
	//	Если ЗначениеЗаполнено(НачальникБО) Тогда
	//		Если НЕ ТекОбъект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", НачальникБО)).Количество()  Тогда
	//			НоваяСтрока = ТекОбъект.ДопСогласование.Вставить(1);
	//			НоваяСтрока.СубъектСогласования  = НачальникБО;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервереЗаявкаНаКадровоеДвижение(ТекОбъект, ТекОснование)
	//заполняем стандартным маршрутом
	ТекОбъект.СтандартныйМаршрут = Истина;
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, , ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, , ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, , ТекОснование.Дата);
	
	//устанавливаем контроль ОФК
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	МаршрутыДвиженияЗаявок.КонтрольОФК,
	               |	МаршрутыДвиженияЗаявок.ТипАвтомаршрута
	               |ИЗ
	               |	Справочник.МаршрутыДвиженияЗаявок КАК МаршрутыДвиженияЗаявок
	               |ГДЕ
	               |	МаршрутыДвиженияЗаявок.Ссылка В(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ТекОбъект.ДопСогласование.Выгрузить().ВыгрузитьКолонку("МаршрутДвижения"));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл		
		Если Выборка.ТипАвтомаршрута = "С группировками" Тогда
			ТекОбъект.ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно;		
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере(ТекОбъект, ТекОснование)
	
	ВидСЗ = БюджетныйНаСервере.ВернутьРеквизит(ТекОснование, "ВидСЗ"); 
	Кому = БюджетныйНаСервере.ВернутьРеквизит(ТекОснование, "Кому"); 
		
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, ТекОснование.Предприятие, ТекОснование.Дата);
	
	ТекОбъект.Предприятие = ТекОснование.Предприятие;
	Если ЗначениеЗаполнено(Кому) Тогда
		Если ТипЗнч(ТекОснование.Кому) = Тип("СправочникСсылка.Пользователи") Тогда
			Если ТекОснование.ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("ИнформационноеПисьмо") Тогда
				НоваяСтрока = ТекОбъект.ДопОповещение.Добавить();
				НоваяСтрока.Пользователь = ТекОснование.Кому;
				НоваяСтрока.СразуПослеСтарта = Ложь;
			Иначе	
				НоваяСтрока = ТекОбъект.ДопСогласование.Добавить();
				НоваяСтрока.СубъектСогласования = ТекОснование.Кому;
			КонецЕсли;	
		Иначе
			Для Каждого ТекПользователь Из ТекОснование.Рецензенты Цикл
				Если ТекОснование.ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("ИнформационноеПисьмо") Тогда
					НоваяСтрока = ТекОбъект.ДопОповещение.Добавить();
					НоваяСтрока.Пользователь = ТекПользователь.Пользователь;
					НоваяСтрока.СразуПослеСтарта = Ложь;
				Иначе	
					НоваяСтрока = ТекОбъект.ДопСогласование.Добавить();
					НоваяСтрока.СубъектСогласования = ТекПользователь.Пользователь;
					//НоваяСтрока.РезультирующееСогласование = ТекПользователь.Пользователь.РезультирующееСогласование;
				КонецЕсли;	
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ТекОснование.Ссылка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") Тогда
		ТекОбъект.Описание = Строка(ТекОснование.ЮрЛицоКомпании) + " - " + Строка(ТекОснование.Контрагент);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ЗаполнитьНаСервереЗаявкаНаТорговлю(ТекОбъект, ТекОснование)
	//добавляем в согласование директора предприятия
	Справочники.СогласованиеОбщее.ДобавитьСтрокуДопСогласование(ТекОбъект, БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(ТекОснование.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.РуководительПроекта), "Руководитель предприятия", Истина);
	
	//заполняем стандартным маршрутом
	ТекОбъект.СтандартныйМаршрут = Истина;
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопСогласование", ТекОснование.Ссылка, , ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопИсполнение", ТекОснование.Ссылка, , ТекОснование.Дата);
	БПСервер.ДобавитьРецензентовВМаршрут(ТекОбъект, "ДопОповещение", ТекОснование.Ссылка, , ТекОснование.Дата);
	
КонецПроцедуры

#КонецОбласти 

Функция СоздаватьЗадачуОзнакомленияАвтору(Заявка)
	Если ТипЗнч(Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаФинансирование") Тогда
		Возврат ?((НЕ ПараметрыСеанса.ДоступныеПользователи.Найти(Автор) = Неопределено), Ложь, Истина) ИЛИ ?((НЕ ПараметрыСеанса.ДоступныеПользователи.Найти(Заявка.Автор) = Неопределено), Ложь, Истина);
	Иначе
		Возврат ?((НЕ ПараметрыСеанса.ДоступныеПользователи.Найти(Автор) = Неопределено), Ложь, Истина);
	КонецЕсли;
КонецФункции // ()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;		

	ТекТочкаМаршрута = БПСервер.ПолучитьТекущуюТочкуМаршрута(Заявка);
	
	Если (ТекТочкаМаршрута = "На подготовке" ИЛИ ТекТочкаМаршрута = Перечисления.СогласованиеОбщееТочкиМаршрута.НаПодготовке) И Не Завершен Тогда //старт процесса
		
		ФормируемыеЗадачи = Новый Массив;
		Действие2ПередСозданиемЗадач(Перечисления.СогласованиеОбщееТочкиМаршрута.Действие2, ФормируемыеЗадачи, Истина);
		Если Не ФормируемыеЗадачи.Количество() Тогда
			Действие3ПередСозданиемЗадач(Перечисления.СогласованиеОбщееТочкиМаршрута.Действие3, ФормируемыеЗадачи, Истина);
		КонецЕсли;
		Если Не ФормируемыеЗадачи.Количество() Тогда
			Действие5ПередСозданиемЗадач(Перечисления.СогласованиеОбщееТочкиМаршрута.Действие5, ФормируемыеЗадачи, Истина);
		КонецЕсли;
		Если Не ФормируемыеЗадачи.Количество() Тогда
			Действие6ПередСозданиемЗадач(Перечисления.СогласованиеОбщееТочкиМаршрута.Действие4, ФормируемыеЗадачи, Истина);
		КонецЕсли;

	КонецЕсли;
	
	БПСервер.БППриЗаписиПриЗаписи(ЭтотОбъект, Ложь);
	
КонецПроцедуры




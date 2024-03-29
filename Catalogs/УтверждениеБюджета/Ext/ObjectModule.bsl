﻿Процедура Действие1ПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, Отказ)
	Для каждого Задача Из ФормируемыеСправочники Цикл
        Задача.Заявка = Заявка;
		Задача.Предприятие = Предприятие;
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
    КонецЦикла;
КонецПроцедуры

Процедура Действие1ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Предприятие = Предприятие;
	Задача.Наименование = "Доработать: " + Строка(ТипБюджета);
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Задача.Исполнитель = Автор;
		
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	Если Ссылка.ПометкаУдаления Тогда //при удалении бизнес-процесса удаляем Справочники
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Задача.Ссылка
		|ИЗ
		|	Справочник.Задача КАК Задача
		|ГДЕ
		|	Задача.БизнесПроцесс = &БизнесПроцесс";
		
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.ПометкаУдаления = Истина;
			ЗадачаОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура Действие2ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Для каждого РольПользователь Из ДопСогласование  Цикл
		Если РольПользователь.Пройден Тогда
			Продолжить;		
		КонецЕсли;
		
		Если РольПользователь.СубъектСогласования.Пустая() Тогда
			Продолжить;		
		КонецЕсли;
		
		//Если ТочкаМаршрутаБизнесПроцесса = Перечисления.Согласование3ТочкиМаршрута.Действие2 Тогда
		//	Если БПСервер.ФинДирекция(РольПользователь.СубъектСогласования) Тогда
		//		Продолжить;			
		//	КонецЕсли;
		//Иначе
		//	Если НЕ БПСервер.ФинДирекция(РольПользователь.СубъектСогласования) Тогда
		//		Продолжить;			
		//	КонецЕсли;		
		//КонецЕсли;
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Предприятие = Предприятие;
		Задача.Наименование = "Утвердить: " + Строка(ТипБюджета);
		
		Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		//Сообщить(ТипЗнч(РольПользователь));
		Если ТипЗнч(РольПользователь.СубъектСогласования) = Тип("СправочникСсылка.Пользователи") Тогда
			Задача.Исполнитель = РольПользователь.СубъектСогласования;
		Иначе
			//дивизионер и директор закреплены за предприятиями, другие должности нет
			//Если РольПользователь.СубъектСогласования = Справочники.Д_Должности.Дивизионер ИЛИ РольПользователь.СубъектСогласования = Справочники.Д_Должности.Директор Тогда
			//	Задача.Исполнитель = Предприятие[РольПользователь.СубъектСогласования.Наименование];
			//Иначе
				Задача.Должность = РольПользователь.СубъектСогласования;			
			//КонецЕсли;			
		КонецЕсли;
				
		Задача.Записать();
		ФормируемыеСправочники.Добавить(Задача);
		
		Прервать;
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОбходЗавершенПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
		Если НЕ Пользователь.Пройден Тогда
			Результат = Ложь;
			Возврат;
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
		Если НЕ ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Согласовано Тогда
			Результат = Истина;
			Возврат;
		КонецЕсли;		
	КонецЦикла; 
	Результат = Ложь;
КонецПроцедуры

//Процедура Согласование2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
//	Для каждого ТекСтрока Из ДопСогласование Цикл
//		Если БПСервер.ФинДирекция(ТекСтрока.СубъектСогласования) Тогда
//			Если НЕ ТекСтрока.Пройден ИЛИ НЕ ТекСтрока.Согласовано Тогда
//				Результат = Истина;
//				Возврат;
//			КонецЕсли;		
//		КонецЕсли;
//	КонецЦикла; 
//	Результат = Ложь;
//КонецПроцедуры

Процедура ОбработкаРезультатаСогласованияОбработка(ТочкаМаршрутаБизнесПроцесса)
	// Вставить содержимое обработчика.
КонецПроцедуры

//Процедура ОбходЗавершен2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
//	Для каждого Пользователь Из ДопСогласование Цикл
//		Если БПСервер.ФинДирекция(Пользователь.СубъектСогласования) Тогда
//			Если НЕ Пользователь.Пройден Тогда
//				Результат = Ложь;
//				Возврат;
//			КонецЕсли;	
//		КонецЕсли;
//	КонецЦикла;	
//	Результат = Истина;
//КонецПроцедуры

Процедура Условие1ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Для каждого Пользователь Из ДопСогласование Цикл
			Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	
	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

//Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
//	Для каждого Пользователь Из ДопСогласование Цикл
//		Если БПСервер.ФинДирекция(Пользователь.СубъектСогласования) Тогда
//			Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
//				Результат = Ложь;
//				Возврат;
//			КонецЕсли;	
//		КонецЕсли;
//	КонецЦикла;	
//	Результат = Истина;
//КонецПроцедуры

Процедура Действие5ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	//определяем исполнителя оплаты
	
	//создаем задачу автору
	Плательщик = Автор;
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Предприятие = Предприятие;
	Задача.Наименование = "Ознакомиться с результатом утверждения: " + Строка(ТипБюджета);
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Если ТипЗнч(Плательщик) = Тип("СправочникСсылка.Пользователи") Тогда
		Задача.Исполнитель = Плательщик;
	Иначе
		Задача.Должность = Плательщик;
	КонецЕсли;
	
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
	
	
КонецПроцедуры

Процедура ОтправитьПисьмоРуководителю()
	Тема = "Новое согласование в электронном документообороте: " + Строка(Заявка);
	Содержание = "Данная заявка была согласована в системе электронного документооборота:
					|" + Строка(Заявка);
	Содержание = Содержание + Символы.ПС + Символы.ПС + "Реквизиты заявки:";
	
	Реквизиты = "
				|Автор: " + Строка(Заявка.Автор) + "
				|Предприятие: " + Строка(Заявка.Предприятие) + "
				|Подразделение: " + Строка(Заявка.Подразделение) + "
				|Грузополучатель: " + Строка(Заявка.Грузополучатель) + "
				|ДатаОтгрузки: " + Формат(Заявка.ДатаОтгрузки, "ДФ=dd.MM.yyyy") + "
				|Количество: " + Строка(Заявка.Количество) + "
				|Цена: " + Строка(Заявка.Цена) + " руб.
				|Верх: " + Строка(Заявка.Верх) + " руб.
				|Доставка: " + Строка(Заявка.Доставка) + " руб.
				|ВидДоставки: " + Строка(Заявка.ВидДоставки) + "
				|Док: " + Строка(Заявка.Док) + "
				|ЦенаДок: " + Строка(Заявка.ЦенаДок) + " руб.
				|ДатаОтгрузкиДок: " + Формат(Заявка.ДатаОтгрузкиДок, "ДФ=dd.MM.yyyy")  + "
				|Отсрочка: " + Строка(Заявка.Отсрочка) + "
				|ПроцентПредоплаты: " + Строка(Заявка.ПроцентПредоплаты);
				
	Рецензенты = Символы.ПС + Символы.ПС + "Заявку согласовали:" + Символы.ПС;
	Для каждого ТекСтрока Из ДопСогласование Цикл
		Рецензенты = Рецензенты + Строка(ТекСтрока.Пользователь) + ?(ПустаяСтрока(ТекСтрока.Пользователь.Должность), "", " (" + Строка(ТекСтрока.Пользователь.Должность) + ")") +
		?(ПустаяСтрока(ТекСтрока.Комментарии), "", " (" + ТекСтрока.Комментарии + ")") + Символы.ПС;	
	КонецЦикла; 
				
	Содержание = Содержание + Реквизиты + Рецензенты;			
	
	Кому = Заявка.РуководительПроекта.EMail;
		
	Подпись = НСтр("ru = 'Сообщение автоматически отправлено из программы 1С:Корпоративный учет.'");
	Подпись = Подпись + Символы.ПС;
	Подпись = Подпись + НСтр("ru = 'Основание: '") + ПолучитьНавигационнуюСсылкуИнформационнойБазы() + "#" + ПолучитьНавигационнуюСсылку(Заявка);
	
	Содержание = Содержание + Символы.ПС + Символы.ПС + Подпись;
	
	ТабДок = Новый ТабличныйДокумент;
	МассивЗаявок = Новый Массив;
	МассивЗаявок.Добавить(Заявка);
	//Документы.Д_ЗаявкаНаОтгрузку.Печать(ТабДок, МассивЗаявок);
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.Записать("C:\1cTemp\tempSales.xls", ТипФайлаТабличногоДокумента.XLS);
	
	
	ТекФайл = Новый Файл("C:\1cTemp\tempSales.xls");
	
	Пока  НЕ ТекФайл.Существует() Цикл
		//ОбработкаПрерыванияПользователя();
	КонецЦикла;

	УчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	СписокФайлов = Новый ТаблицаЗначений;
	СписокФайлов.Колонки.Добавить("ИмяФайла");
	СписокФайлов.Колонки.Добавить("ПолноеИмя");
	НоваяСтрока = СписокФайлов.Добавить();
	НоваяСтрока.ИмяФайла = Строка(Заявка) + ".xls";
	НоваяСтрока.ПолноеИмя = "C:\1cTemp\tempSales.xls";
	
	//УправлениеЭлектроннойПочтой.ОтправитьПоЭлектроннойПочте(
	//УчетнаяЗапись,
	//Кому,
	//Тема,
	//Содержание,
	//ВажностьИнтернетПочтовогоСообщения.Обычная,
	//СписокФайлов,
	//Ложь);
	
КонецПроцедуры


Процедура СогласованоДействие4ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие4;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Ссылка.Пустая() Тогда
		ДатаНачала = ТекущаяДата();	
	КонецЕсли;
	Если Завершен И ДатаЗавершения = Дата('00010101') Тогда
		ДатаЗавершения = ТекущаяДата();	
	КонецЕсли;
	
	Для каждого ТекСтрока Из ДопСогласование Цикл
		Если Не ЗначениеЗаполнено(ТекСтрока.СубъектСогласования) Тогда
			Сообщить("В ТЧ Согласования найдено пустое значение!");
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры









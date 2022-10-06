﻿Процедура Действие1ПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, Отказ)
	Для каждого Задача Из ФормируемыеСправочники Цикл
        Задача.Заявка = Заявка;
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
    КонецЦикла;
КонецПроцедуры

Процедура Действие1ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Наименование = "Доработать";
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Задача.Исполнитель = Автор;
		
	Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
	
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
	
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
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Наименование = "Согласовать";
		
		Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		//Сообщить(ТипЗнч(РольПользователь));
		Задача.Исполнитель = РольПользователь.СубъектСогласования;
		
		Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
				
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
			Если Пользователь.Пройден И НЕ Пользователь.Согласовано Тогда
				Результат = Ложь;
				Возврат;
			КонецЕсли;	

	КонецЦикла;	
	Результат = Истина;
КонецПроцедуры

Процедура Условие2ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие5;
КонецПроцедуры

Процедура Действие5ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	//определяем исполнителя оплаты
	
	МассивОзнакомителей = Новый Массив;
	//Админ = Константы.Администратор.Получить();
	//МассивОзнакомителей.Добавить(Админ);
	
	СоздПольз = Заявка.СозданныйПользователь;
	Если ЗначениеЗаполнено(СоздПольз) И МассивОзнакомителей.Найти(СоздПольз) = Неопределено Тогда
		МассивОзнакомителей.Добавить(СоздПольз);
	Иначе
		Если МассивОзнакомителей.Найти(Автор) = Неопределено И НЕ Автор = ПараметрыСеанса.ТекущийПользователь И Автор = ОтИмени Тогда
			МассивОзнакомителей.Добавить(Автор);
		КонецЕсли;
		
		Если МассивОзнакомителей.Найти(ОтИмени) = Неопределено И ТипЗнч(ОтИмени) = Тип("СправочникСсылка.Пользователи") 
			И НЕ ОтИмени = ПараметрыСеанса.ТекущийПользователь И НЕ Автор = ОтИмени Тогда
			МассивОзнакомителей.Добавить(ОтИмени);
		КонецЕсли;
	КонецЕсли;
	
	//Для каждого ТекСтрока Из ДопОповещение Цикл
	//	Если МассивОзнакомителей.Найти(ТекСтрока.Пользователь) = Неопределено Тогда
	//		МассивОзнакомителей.Добавить(ТекСтрока.Пользователь);
	//	КонецЕсли;
	//КонецЦикла; 
	
	Для каждого ТекПользователь Из МассивОзнакомителей Цикл
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Наименование = "Ознакомиться с результатом";
		
		Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		Задача.Исполнитель = ТекПользователь;
		
		Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
		
		Задача.Записать();
		ФормируемыеСправочники.Добавить(Задача);
		
	КонецЦикла;
	
	Если НЕ МассивОзнакомителей.Количество() Тогда
		СогласованоДействие4 = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура Действие3ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Наименование = "Рассмотреть";
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Если ЗначениеЗаполнено(Администратор) Тогда
		Задача.Исполнитель = Администратор;
	Иначе
		Задача.Исполнитель = Константы.Администратор.Получить();
	КонецЕсли;
	
	Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
	
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
КонецПроцедуры

Процедура СогласованоДействие4ПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = СогласованоДействие4;
КонецПроцедуры

Процедура Действие4ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Задача = Справочники.Задача.СоздатьЭлемент();		
	Задача.Заявка = Заявка;
	Задача.Дата = ТекущаяДата();
	Задача.Наименование = "Выполнить";
	
	Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
	Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
	Задача.ВРаботе = Истина;
	Задача.СрокВыполнения = Заявка.СрокОкончанияРабот;
	Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
	Задача.Описание = Описание;
	Задача.Исполнитель = Администратор;
	
	Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
	
	Задача.Записать();
	ФормируемыеСправочники.Добавить(Задача);
	
КонецПроцедуры

Процедура Действие6ПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеСправочники, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	//определяем исполнителя оплаты
	
	МассивОзнакомителей = Новый Массив;
	Админ = Константы.Администратор.Получить();
	МассивОзнакомителей.Добавить(Админ);
	
	Для каждого ТекПользователь Из МассивОзнакомителей Цикл
		
		Задача = Справочники.Задача.СоздатьЭлемент();		
		Задача.Заявка = Заявка;
		Задача.Дата = ТекущаяДата();
		Задача.Наименование = "Проверить выполнение";
		
		Задача.БизнесПроцесс  = ЭтотОбъект.Ссылка;
		Задача.ТочкаМаршрута  = ТочкаМаршрутаБизнесПроцесса;
		
		Задача.Автор = ПараметрыСеанса.ТекущийПользователь;
		Задача.Описание = Описание;
		Задача.Исполнитель = ТекПользователь;
		
		Задача.Проект = Документы.Д_ОбращенияВТехПоддержку.ПолучитьРПервогоРодителяПроекта(Заявка.Проект);
		
		Задача.Записать();
		ФормируемыеСправочники.Добавить(Задача);
		
	КонецЦикла; 
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	Если Не Заявка.Проведен Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаявкаОбъект = Заявка.ПолучитьОбъект();
		ЗаявкаОбъект.Записать(РежимЗаписиДокумента.Проведение);
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры









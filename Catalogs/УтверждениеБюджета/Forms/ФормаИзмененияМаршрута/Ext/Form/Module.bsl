﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекБп = Параметры.ТекущийБизнесПроцесс;
	ТекДокумент = Параметры.ТекущийДокумент;
	Для каждого ТекСтрока Из ТекБп.ДопСогласование Цикл
		Если НЕ ТекСтрока.Пройден Тогда
			НоваяСтрока = Список.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);	
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Исполнитель
	|ИЗ
	|	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БизнесПроцесс
	               |	И Задача.Выполнена = ЛОЖЬ
	               |	И Задача.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБп);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НайденныеИсполнители = Список.НайтиСтроки(Новый Структура("СубъектСогласования", Выборка.Исполнитель));
		Для каждого ТекСтрока Из НайденныеИсполнители Цикл
			ТекСтрока.ТекущийИсполнитель = Истина;		
		КонецЦикла;
	КонецЦикла;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СписокУдаляемых = "";
	Для каждого ТекСтрока Из Список Цикл
		Если ТекСтрока.Использование И ПустаяСтрока(ТекСтрока.Перенаправить) Тогда
			СписокУдаляемых = СписокУдаляемых + Строка(ТекСтрока.СубъектСогласования) + ", ";		
		КонецЕсли;	
	КонецЦикла;
	Если НЕ СписокУдаляемых = "" Тогда
		СписокУдаляемых = Лев(СписокУдаляемых, СтрДлина(СписокУдаляемых) - 2);
	КонецЕсли;
	
	Если НЕ СписокУдаляемых = "" Тогда
		Если Вопрос("Пользователи " + СписокУдаляемых + " будут удалены из текущего маршрута. Вы уверены?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет  Тогда
			Возврат;		
		КонецЕсли;
	КонецЕсли;
	
	
	Попытка
		Отказ = ИзменитьДопСогласование();	
	Исключение
		Предупреждение("Не удалось изменить маршрут бизнес-процесса.");	
		Отказ = Новый Структура("Отказ, Причина", Ложь, "");
	КонецПопытки;
	Если Отказ.Отказ Тогда
		Предупреждение(Отказ.Причина);
	Иначе
		ОповеститьОбИзменении(ТекБП);
		Закрыть();
	КонецЕсли;		
КонецПроцедуры

&НаСервере
Функция ИзменитьДопСогласование()
	НачатьТранзакцию();
	ТекБПОбъект = ТекБП.ПолучитьОбъект();
	Используемые = Список.НайтиСтроки(Новый Структура("Использование", Истина));
	Для каждого ТекСтрока Из Используемые Цикл
		ОотбранныеСтроки = ТекБПОбъект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", ТекСтрока.СубъектСогласования));
		Если ОотбранныеСтроки.Количество() Тогда //если заменяются старые
			Для каждого НайденнаяСтрока Из ОотбранныеСтроки Цикл
				Если НайденнаяСтрока.Пройден Тогда
					Возврат Новый Структура("Отказ, Причина", Истина, "Пользователь " + Строка(НайденнаяСтрока.СубъектСогласования) + " уже пройден.");
				Иначе
					ИсходныйПользователь = НайденнаяСтрока.СубъектСогласования;
					ИндексСтроки = ТекБПОбъект.ДопСогласование.Индекс(НайденнаяСтрока);
					
					Если НЕ ПустаяСтрока(ТекСтрока.Перенаправить) Тогда
						НоваяСтрока = ТекБПОбъект.ДопСогласование.Вставить(ИндексСтроки);
						НоваяСтрока.СубъектСогласования = ТекСтрока.Перенаправить;
						//НоваяСтрока.РезультирующееСогласование = ТекСтрока.Перенаправить.РезультирующееСогласование;
					КонецЕсли;
					
					ТекБПОбъект.ДопСогласование.Удалить(НайденнаяСтрока);
					ТекБПОбъект.Записать();
					ИзменитьЗадачу(ТекБП, ИсходныйПользователь, ТекСтрока.Перенаправить);
				КонецЕсли;
			КонецЦикла;
		Иначе//если добавляются новые
			НоваяСтрока = ТекБПОбъект.ДопСогласование.Добавить();
			НоваяСтрока.СубъектСогласования = ТекСтрока.Перенаправить;
			//НоваяСтрока.РезультирующееСогласование = ТекСтрока.Перенаправить.РезультирующееСогласование;
			Если ТекБПОбъект.Завершен Тогда
				ТекБПОбъект.Стартован = Ложь;
				ТекБПОбъект.Завершен = Ложь;
				ТекБПОбъект.Старт();
			ИначеЕсли ТекСтадияБПознакомление(ТекБП)Тогда
				УдалитьСправочникиОзнакомления(ТекБП);	
				ТекБПОбъект.Стартован = Ложь;
				ТекБПОбъект.Старт();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла; 
	ТекБПОбъект.Записать();
	ТекБП.Заявка.ПолучитьОбъект().Записать();
	ЗафиксироватьТранзакцию();
	Возврат Новый Структура("Отказ, Причина", Ложь, "");
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьСправочникиОзнакомления(ТекБП)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.ТочкаМаршрута,
	               |	Задача.Ссылка
	               |ИЗ
	               |	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БизнесПроцесс
	               |	И Задача.Выполнена = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБП);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТекЗадачаОбъект.Удалить();
	КонецЦикла;
КонецПроцедуры // ()

&НаСервереБезКонтекста
Функция ТекСтадияБПознакомление(ТекБП)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.ТочкаМаршрута,
	               |	Задача.Ссылка
	               |ИЗ
	               |	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БизнесПроцесс
	               |	И Задача.Выполнена = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБП);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ТочкаМаршрута = Перечисления.УтверждениеБюджетаТочкиМаршрута.Действие5 Тогда
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;
	Возврат Ложь;
КонецФункции // ()



&НаСервереБезКонтекста
Процедура ИзменитьЗадачу(ТекБп, ИсходныйПользователь, КонечныйПользователь)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.Ссылка
	               |ИЗ
	               |	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БизнесПроцесс
	               |	И Задача.Выполнена = ЛОЖЬ
	               |	И Задача.ПометкаУдаления = ЛОЖЬ
	               |	И Задача.Исполнитель = &Исполнитель";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", ТекБп);
	Запрос.УстановитьПараметр("Исполнитель", ИсходныйПользователь);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	//выполняем задачу у исходного пользователя с комментариями "перенаправлено"
	Пока Выборка.Следующий() Цикл
		//ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Если ПустаяСтрока(КонечныйПользователь) Тогда
			Комментарий = "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " удалил из маршрута пользователя " + Строка(ИсходныйПользователь) + ".";
		Иначе
			Комментарий = "Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " перенаправил бизнес процесс на " + Строка(КонечныйПользователь) + ".";
		КонецЕсли;
		//ЗадачаОбъект.Комментарии = Комментарий;
		//ЗадачаОбъект.Пользователь = ПараметрыСеанса.ТекущийПользователь;
		//ЗадачаОбъект.Выполнена = Истина;
		//ЗадачаОбъект.Записать();
		//
		////создаем новую задачу для пользователя
		//Если НЕ ПустаяСтрока(КонечныйПользователь) Тогда
		//	НоваяЗадача = ЗадачаОбъект.Скопировать();
		//	НоваяЗадача.ДатаНачала = ТекущаяДата();
		//	НоваяЗадача.ДатаИсполнения = '00010101000000';
		//	НоваяЗадача.Дата = ТекущаяДата();
		//	НоваяЗадача.Исполнитель = КонечныйПользователь;
		//	НоваяЗадача.Пользователь = "";
		//	НоваяЗадача.Комментарии = "";
		//	НоваяЗадача.Наименование = СтрЗаменить(НоваяЗадача.Наименование, Строка(ИсходныйПользователь), Строка(КонечныйПользователь));
		//	НоваяЗадача.Выполнена = Ложь;
		//	НоваяЗадача.Записать();
		//	НоваяЗадача.Заявка.ПолучитьОбъект().Записать();
		//КонецЕсли;
		
		БПСервер.ВыполнитьЗадачу(Выборка.Ссылка, 0, "", Комментарий);
	КонецЦикла; 
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;	
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СписокПеренаправитьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Элементы.Список.ТекущиеДанные.Использование = Истина;	
	КонецЕсли;
КонецПроцедуры
 

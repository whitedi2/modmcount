﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОповещатьПользователейПриИзменении(0);
	ТипСогласованияПриИзменении(0);
	
	//интерфейс
	ВидДелегированияПриИзменении(Неопределено);
	
	Подчиненные = БПСервер.ПолучитьМассивПрямыхПодчиненных();
	БюджетныйНаКлиенте.ЗаполнитьСписокРеквизита(ЭтаФорма, "СписокВыбора_Замещающий", Подчиненные);
	
	ВидимостьСотрудников();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьРольАдмина()

	возврат "АдминистраторСистемы";	

КонецФункции // ()


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	НаименованиеОтпускника = ?(Объект.ОтпускникОтсутствуетВБазе, Строка(Объект.СотрудникОтпускник), Строка(Объект.Пользователь));
	НаименованиеЗамещающего = ?(Объект.ОтпускникОтсутствуетВБазе, Строка(Объект.СотрудникЗамещающий), Строка(Объект.Замещающий));
	Объект.Наименование = "Отпуск " + НаименованиеОтпускника + " с " + Формат(Объект.ДатаНачала, "ДФ=dd.MM.yyyy") + " по " + Формат(Объект.ДатаОкончания, "ДФ=dd.MM.yyyy") + ". Замещает " + НаименованиеЗамещающего;
	Объект.Автор = БюджетныйНаСервере.ПолучитьПользователя();
	
	Если БПЗапущен(Объект.Ссылка) И НЕ Объект.Ссылка.Пустая() И НЕ Объект.ПометкаУдаления И НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		Сообщить("Заявка на отпуск в работе. Редактирование невозможно!");
		Отказ = Истина;
		Возврат;		
	КонецЕсли;
	
	//Проверка наложения периодов
	Если Объект.ДатаНачала > Объект.ДатаОкончания Тогда
		Сообщить("Дата начала не может быть больше даты окончания.");
		Отказ = Истина;
		Возврат;		
	КонецЕсли;
	
	Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() И НЕ Объект.ТехническийОтпуск И Не Объект.ОтпускникОтсутствуетВБазе Тогда
		
		Если ПроверитьПериодыСервер() Тогда
			Сообщить("Текущий период отпуска накладывается на другие отпуска.");
			Отказ = Истина;
			Возврат;		
		КонецЕсли;
		
		Если НЕ Объект.ДопСогласование.Количество() И НЕ Объект.ПометкаУдаления И ПустаяСтрока(Объект.ДокОснование) Тогда
			
			Если Вопрос("Вы уверены что ни с кем не нужно согласовывать Ваш отпуск?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Объект.ПользовательСогласовал = Истина;
	Отказ = Не ПроверитьЗаполнение();
	ОповеститьОбИзменении(Тип("СправочникСсылка.Задача"));
	
КонецПроцедуры


&НаКлиенте
Процедура Согласование1ПользовательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	//Если выбрана группа
	Если Не ВыбранноеЗначение = Неопределено Тогда
		Если ПроверкаГруппы(ВыбранноеЗначение) Тогда
			СтандартнаяОбработка = Ложь;
			МассивПользователей = ДобавитьГруппу(ВыбранноеЗначение);
			Индекс = 0;
			Для каждого ТекПользователь Из МассивПользователей Цикл
				Если Индекс Тогда
					Элементы.Согласование1.ДобавитьСтроку();
				КонецЕсли;
				Элементы.Согласование1.ТекущиеДанные.Пользователь = ТекПользователь;
				Индекс = Индекс + 1;
			КонецЦикла; 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверкаГруппы(ВыбранноеЗначение)

	Возврат ВыбранноеЗначение.ЭтоГруппа;	

КонецФункции // ()

&НаСервереБезКонтекста
Функция ДобавитьГруппу(ВыбранноеЗначение)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.Родитель = &Родитель
	|	И Пользователи.ЭтоГруппа = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Родитель", ВыбранноеЗначение);
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	
КонецФункции // ()

&НаКлиенте
Процедура ОповещатьПользователейПриИзменении(Элемент)
	Элементы.Оповещение.Видимость = (Объект.ОповещатьПользователей = "По списку");
	Элементы.ТекстНовости.Видимость = (Объект.ОповещатьПользователей = "Публикация в ленте новостей");
	Элементы.Декорация2.Видимость = (Объект.ОповещатьПользователей = "Публикация в ленте новостей");
	
	Если Объект.ОповещатьПользователей = "Публикация в ленте новостей" Тогда
		Объект.ТекстНовости = "Пользователь " + Строка(Объект.Пользователь) + " будет в отпуске с " + Формат(Объект.ДатаНачала, "ДЛФ=DD") + " по " + 
		Формат(Объект.ДатаОкончания, "ДЛФ=DD") + ". В указанный период его обязанности будет исполнять пользователь " + Строка(Объект.Замещающий) + ".
		|
		|Согласовано с:";
		Для каждого ТекСогласователь Из Объект.ДопСогласование Цикл
			Объект.ТекстНовости = Объект.ТекстНовости + "
			|" + Строка(ТекСогласователь.СубъектСогласования);
		КонецЦикла; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьОтпуск(Команда)
	//Если Объект.ТипСогласования = "Согласовать отпуск" И НЕ Объект.Согласование.Количество() Тогда
	//	Предупреждение("Укажите пользователей для согласования отпуска, или укажите что отпуск уже согласован.");
	//	Элементы.Группа2.ТекущаяСтраница = Элементы.Согласование;
	//	Возврат;
	//КонецЕсли;
	
	Если Объект.ДопСогласование.НайтиСтроки(новый Структура("СубъектСогласования", Объект.Замещающий)).Количество() = 0 И Не Объект.ОтпускникОтсутствуетВБазе Тогда
		НоваяСтрока = Объект.ДопСогласование.Вставить(0);
		НоваяСтрока.СубъектСогласования = Объект.Замещающий;
	КонецЕсли;
	
	
	Если  Записать() Тогда
		СогласоватьОтпускСервер();
		ОповеститьОбИзменении(Тип("СправочникСсылка.Задача"));
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СогласоватьОтпускСервер()
	//задача для замещающего
	Если Не Объект.ОтпускникОтсутствуетВБазе Тогда
		Если НЕ Объект.ДопСогласование.Количество() ИЛИ НЕ Объект.ТипСогласования = "Согласовать отпуск" Тогда
			НачатьТранзакцию();
			Задача = Задачи.Задача.СоздатьЭлемент();		
			Задача.Заявка = Объект.Ссылка;
			Задача.Дата = ТекущаяДата();
			Задача.Наименование = "Принять обязанности отпускника: " + Строка(Объект.Пользователь);
			Задача.Автор = БюджетныйНаСервере.ПолучитьПользователя();
			Задача.Описание = Объект.Примечания;
			Задача.Исполнитель = Объект.Замещающий;
			Задача.Записать();
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	КонецЕсли;
	
	//задача для согласователей
	НачатьТранзакцию();
	Если Объект.ТипСогласования = "Согласовать отпуск" Тогда
		
		Для каждого ТекСогласователь Из Объект.ДопСогласование Цикл
			Если ТекСогласователь.Пройден И ТекСогласователь.Согласовано Тогда
				Продолжить;
			КонецЕсли;	
			Задача = Задачи.Задача.СоздатьЭлемент();		
			Задача.Заявка = Объект.Ссылка;
			Задача.Дата = ТекущаяДата();
			Задача.Наименование = "Согласовать отпуск " + Строка(Объект.Пользователь) + " с: " + Строка(ТекСогласователь.СубъектСогласования);
			Задача.Автор = БюджетныйНаСервере.ПолучитьПользователя();
			Задача.Описание = Объект.Примечания;
			Задача.Исполнитель = ТекСогласователь.СубъектСогласования;
			Задача.Записать();
			Прервать;
		КонецЦикла;
		
	КонецЕсли;
	ЗафиксироватьТранзакцию();
	
	ПринятьСервер(Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция БПЗапущен(Заявка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Ссылка
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Заявка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Возврат Выборка.Количество();	
	
КонецФункции // ()

&НаСервере
Функция ПроверитьПериодыСервер()
    
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сабОтпускаСотрудников.Пользователь,
	               |	сабОтпускаСотрудников.Замещающий,
	               |	сабОтпускаСотрудников.ДатаОкончания
	               |ИЗ
	               |	Справочник.сабОтпускаСотрудников КАК сабОтпускаСотрудников
	               |ГДЕ
	               |	(сабОтпускаСотрудников.ДатаНачала >= &ДатаНачала
	               |				И сабОтпускаСотрудников.ДатаНачала <= &ДатаОкончания
	               |			ИЛИ сабОтпускаСотрудников.ДатаОкончания >= &ДатаНачала
	               |				И сабОтпускаСотрудников.ДатаОкончания <= &ДатаОкончания)
	               |	И сабОтпускаСотрудников.Пользователь = &Пользователь
	               |	И сабОтпускаСотрудников.ПометкаУдаления = ЛОЖЬ
	               |	И (НЕ сабОтпускаСотрудников.Ссылка = &Ссылка)";
	
	Запрос.УстановитьПараметр("ДатаНачала", Объект.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Объект.ДатаОкончания);
	Запрос.УстановитьПараметр("Пользователь", Объект.Пользователь);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Возврат Выборка.Количество();
	
КонецФункции // ()

&НаКлиенте
Процедура Редактировать(Команда)
	Если НЕ БПЗапущен(Объект.Ссылка) Тогда
		Предупреждение("Согласование не запущено!");
		Возврат;
	КонецЕсли;
	Если Вопрос("Разрешение редактирования повлечет отмену всех согласований. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да  Тогда
		Элементы.Группа2.Доступность = Истина;
		Для каждого ТекСтрока Из Объект.ДопСогласование Цикл
			ТекСтрока.Пройден = Ложь;
			ТекСтрока.Согласовано = Ложь;
		КонецЦикла;
		Объект.ЗамещающийСогласовал = Ложь;
		УдалитьЗадачи(Объект.Ссылка);
		Элементы.ФормаРедактировать.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УдалитьЗадачи(Ссылка)
	//удаляем задачи
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	Задача.Ссылка
				   |ИЗ
				   |	Справочник.Задача КАК Задача
				   |ГДЕ
				   |	Задача.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Ссылка);
	
	Результат = Запрос.Выполнить();
	ВыборкаЗадачи = Результат.Выбрать();
	
	Пока ВыборкаЗадачи.Следующий() Цикл
		ТекБП = ВыборкаЗадачи.Ссылка.ПолучитьОбъект();
		ТекБП.Удалить();
	КонецЦикла;
    
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	Объект.ПометкаУдаления = Истина;
	Если Записать() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСогласованияПриИзменении(Элемент)
	Если Объект.ТипСогласования = "Согласовать отпуск" Тогда
		Элементы.Согласование1.Видимость = Истина;
		Элементы.ДокОснование.Видимость = Ложь;
	Иначе
		Элементы.Согласование1.Видимость = Ложь;
		Элементы.ДокОснование.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПринятьСервер(РезультатЗамещения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Задача.Ссылка
	|ИЗ
	|	Справочник.Задача КАК Задача
	|ГДЕ
	|	Задача.Заявка = &Заявка
	|	И Задача.Исполнитель = &Исполнитель";
	
	Запрос.УстановитьПараметр("Заявка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Исполнитель", Объект.Пользователь);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		БПСервер.ВыполнитьЗадачу(Выборка.Ссылка,0, ?(РезультатЗамещения, "Да", "Нет"), Объект.КомментарийЗамещающего);	
		
	КонецЦикла;
	

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала);
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	Объект.ДатаОкончания = КонецДня(Объект.ДатаОкончания);
КонецПроцедуры

&НаКлиенте
Процедура ДелегироватьЗадачиНаПодчиненныхПриИзменении(Элемент)
	Элементы.Замещающий.АвтоОтметкаНезаполненного = НЕ Объект.ДелегироватьЗадачиНаПодчиненных;
	Элементы.Замещающий.ОтметкаНезаполненного = НЕ Объект.ДелегироватьЗадачиНаПодчиненных;
КонецПроцедуры

&НаКлиенте
Процедура ЗамещающийПриИзменении(Элемент)
	
	Объект.СотрудникЗамещающий = ПолучитьСотрудникаПоПользователю(Объект.Замещающий);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидДелегированияПриИзменении(Элемент)
	Если Объект.ВидДелегирования = "Замещающему" Тогда
		Элементы.ВидДелегирования.Подсказка = "Задачи отпускника будут приходить одному замещающему. Замещающий иммет все права отпускника по выполнению задач. Также замещающему добавляется доступность всех документов по доступным предприятиям отпускника.";
	Иначе
		Элементы.ВидДелегирования.Подсказка = "Задачи отпускника будут распределяться между его прямыми подчиненными. Программа автоматически будет пытаться распределить ваши задачи, а в случае невозможности делегирования, задача будет доступна только вам, или замещающему.";
	КонецЕсли;
	//Элементы.Замещающий.Доступность = (Объект.ВидДелегирования = "Замещающему");
	Элементы.Замещающий.АвтоОтметкаНезаполненного = (Объект.ВидДелегирования = "Замещающему");
	Элементы.Замещающий.ОтметкаНезаполненного = (Объект.ВидДелегирования = "Замещающему");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Пользователь = БюджетныйНаСервере.ПолучитьПользователя();
		Объект.СотрудникОтпускник = ПолучитьСотрудникаПоПользователю(Объект.Пользователь);
		Объект.ВидДокумента = "Регламентированный отпуск";
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	Элементы.Пользователь.Доступность = БюджетныйНаСервере.РольАдминаДоступнаСервер();
	
	Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		Если БПЗапущен(Объект.Ссылка) И НЕ Объект.Ссылка.Пустая() Тогда	
			Элементы.Группа2.Доступность = Ложь;
			Элементы.ФормаРедактировать.Доступность = Истина;
		КонецЕсли;
	КонецЕсли;
	
	//заполняем по автомаршрутам
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		БПСервер.ДобавитьРецензентовВМаршрут(Объект, "ДопСогласование", Объект.Ссылка, Неопределено, ТекущаяДата());
		Если Объект.ДопСогласование.Количество() Тогда
			Объект.ИспользованиеАвтомаршрутизации = Истина;
			Элементы.ТипСогласования.Доступность = Ложь;
			Элементы.Согласование1.Доступность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗамещающийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Элементы.СписокВыбора_Замещающий.СписокВыбора.Количество() Тогда
		
		ТекЗначение = ВыбратьИзСписка(Элементы.СписокВыбора_Замещающий.СписокВыбора, Элемент, Элементы.СписокВыбора_Замещающий.СписокВыбора.НайтиПоЗначению(Объект.Замещающий));	
		БюджетныйНаКлиенте.ПриНачалеВыбораРеквизитаВСписке(ЭтаФорма, "СписокВыбора_Замещающий", ТекЗначение, "Пользователи", Объект.Замещающий, СтандартнаяОбработка, Ложь);
	Иначе
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", Новый Структура("ТекущаяСтрока", Объект.Замещающий) ,Элемент); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеАвтомаршрутизацииПриИзменении(Элемент)
	Элементы.ТипСогласования.Доступность = НЕ Объект.ИспользованиеАвтомаршрутизации;
	Элементы.Согласование1.Доступность = НЕ Объект.ИспользованиеАвтомаршрутизации;
КонецПроцедуры

&НаКлиенте
Процедура ОтпускникОтсутствуетВБазеПриИзменении(Элемент)
		
	ВидимостьСотрудников();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	
	Объект.СотрудникОтпускник = ПолучитьСотрудникаПоПользователю(Объект.Пользователь);
	
КонецПроцедуры

Функция ПолучитьСотрудникаПоПользователю(Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Ссылка
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Ссылка;
	КонецЦикла;
	
	Возврат Справочники.Сотрудники.ПустаяСсылка();
	
КонецФункции	

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	ВидимостьСотрудников();	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьСотрудников()
	
	Элементы.СотрудникОтпускник.Видимость = Не (Объект.ВидДокумента = "Техническое замещение") И Объект.ОтпускникОтсутствуетВБазе;
	Элементы.СотрудникЗамещающий.Видимость = Не (Объект.ВидДокумента = "Техническое замещение") И Объект.ОтпускникОтсутствуетВБазе;
	
	Элементы.Пользователь.Видимость = Не Объект.ОтпускникОтсутствуетВБазе;
	Элементы.Замещающий.Видимость = Не Объект.ОтпускникОтсутствуетВБазе;
	Элементы.ВидДелегирования.Видимость = Не Объект.ОтпускникОтсутствуетВБазе;
	
	Если Объект.ОтпускникОтсутствуетВБазе Тогда
		Элементы.СотрудникОтпускник.Заголовок = "Отпускник (сотрудник)";
		Элементы.СотрудникЗамещающий.Заголовок = "Замещающий (сотрудник)";
	Иначе
		Элементы.СотрудникОтпускник.Заголовок = "сотрудник";
		Элементы.СотрудникЗамещающий.Заголовок = "сотрудник";
	КонецЕсли;	
	
КонецПроцедуры	
	
	